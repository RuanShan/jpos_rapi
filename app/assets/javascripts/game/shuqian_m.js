/**
 * Created by zxywx on 2016/10/24.
 */

var shuqian = {
    check_in_url:'',
    play_url:'',
    stopAnimate: 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend',
    //大屏幕ID
    companyID: 0,
    //是否是测试
    isTest: 1,
    //金币数量
    score: 0,
    displayPlayers: 0,
    touch: {},
    cd: 0,
    //CD 当前倒计时秒数
    nowCd: 0,
    //资源路径
    resPath: '',
    //Ws链接状态 'close' 'open'
    connectStatus: 'close'
};

/**
 * 初始化
 */
shuqian.init = function () {
  shuqian.displayPlayers = WechatMore.game_display_players;
  shuqian.check_in_url = WechatMore.routes.check_in_game_url;
  shuqian.play_url = WechatMore.routes.play_game_url;
  shuqian.rem();
  window.addEventListener('resize', shuqian.rem, false);
  $(".step.step-1").show();
  shuqian.channel = App.counting_game_channel = App.cable.subscriptions.create(
    {
      channel:"GameRoundChannel",
      game_round_id: WechatMore.game_round_id,
      terminal: WechatMore.terminal,
      game_player_id: WechatMore.game_player_id
    },
    {
      connected: function() {
        console.debug("build channel parmas player_id=" + WechatMore.game_player_id + "game_round_id="+ WechatMore.game_round_id );
        // Called when the subscription is ready for use on the server
        this.perform('game_state');
      },

      disconnected: function() {
        setTimeout(function () {
            location.reload();
        }, 2000);
      },

      received: function(data) {
        //{now, action，state, game_roun}
        var action = data.action;
        var now = new Date(data.now);
        var game_round = data.game_round;
        var state = shuqian.nowStatus = data.state;
        var nowCd = shuqian.nowCd = data.seconds;

        App.debug( state+ ','+ action +','+ nowCd);
        // 同步指令
        if( data.action == 'sync_cd' )
        {
          shuqian.syncCountdown();
        }else {
          shuqian.initUI(game_round);
        }

        if( data.action == 'game_state')
        {

        }
        else if( data.action == 'start')
        {
          //开始游戏
          shuqian.cd = game_round.countdown;
          $('#countdown .time span').text(shuqian.cd);
          $('#countdown').animate({ opacity:1 }, 1000);
          //震动
          var supportsVibrate = "vibrate" in navigator;
          if(supportsVibrate){
              navigator.vibrate(600);
          }
          //倒计时
          //shuqian.endCountDown(shuqian.cd);
        }
        else if( data.action == 'complete')
        {
          //大屏幕端已结束
          shuqian.fire('player_info');
          shuqian.fire('rank', {  "type": 'final' });
        }
        else if( data.action == 'player_info')
        {
          var player = data.game_player;
          $('.b_score').html(  player.score );
          $('.b_rank').html(  player.rank );

          if( player.rank <= shuqian.displayPlayers )
          {
            $('.b_self').hide();
          }
        }
        else if( data.action == 'final_rank')
        {
          //location.reload();
          shuqian.finalRank(data.game_players);
        }
        // Called when there's incoming data on the websocket for this channel
        $('.b-state-msg').html( data.t_state);
      }
    }
  )

  //数钱动画相关
  shuqian.touchLoad();
  //资源加载
  //shuqian.audioDing = new Audio('/audios/game/shuqian/coin.mp3');

};

// 只在初始化的时候调用
shuqian.initUI = function(game_round)
{
  var state = shuqian.nowStatus;

  if( state == 'starting')
  {
    shuqian.startCountDown( );
  }
  else if( state == 'started')
  {
    $('#running').show();
    $('#wrap').hide();
    //shuqian.endCountDown( );
  }
  else if( state == 'completed')
  {
    //$('.b_score').html(  );
    $('#wrap').hide();
    $('#running').hide();
    $('#result').show();
  }

}

shuqian.syncCountdown = function(){
  var state = shuqian.nowStatus;
  var nowCd = shuqian.nowCd;

  if( state == 'starting')
  {
    $('.b_game .b_title.starting span').text(nowCd);
    $('.b_countdown ').text(nowCd);
  }
  else if( state == 'started')
  {
    //由于手机网络可能会慢些，可能导致计数结果不准确。当还有1秒时，即停止计数
    if( nowCd <= 1)
    {
      // 显示遮罩，禁止数钱
      $('.b_overing').show();
      // 设置状态停止计数，
      shuqian.nowStatus = 'completing';
    }
    $('.b_heading .b_name').html( '距本轮结束还剩:'+nowCd+'秒');
    //发送数钱数量
    //console.debug("first.touch_count"+shuqian.score);
    shuqian.fire('touch_count', { 'score': shuqian.score });
  }
}


shuqian.rem = function() {
  var docEl = document.documentElement;
  var w = docEl.clientWidth;
  if (w > 640) {
    w = 640;
  }
  oSize = w / 6.4;
  if (oSize > 100) {
    oSize = 100;
  }
  //docEl.style.fontSize = oSize + 'px';
  $("#game_box").css('fontSize',oSize + 'px' );
}

/**
 * 开始前的倒计时
 * @param nowCd
 */
shuqian.startCountDown = function (nowCd) {
    var cd = nowCd;
    $('.b_game .b_title.starting span').text(cd);
}


/**
 * 数金币动画
 */
shuqian.touchLoad = function () {
    shuqian.touch = {
      startY: 0,
      time: 60,
      money: 0,
      isExit: false,
      maxMoney: 22,
      rank: 11,
      currenImgId: 1
    };
    // 禁止iphone 滑屏
    $( ".iphone_cover, .overing").on('touchstart', function(event) {
      event.preventDefault();
    });
    var imgSrc = $('.money img:first').attr('src');

    //移动端滚动事件
      $('.money div').on('touchstart', function(event) {
    		shuqian.touch.startY = event.originalEvent.changedTouches[0].clientY;
        event.preventDefault();
    	});
    	$('.money div').on('touchend', function(event) {
    		var offsetY = event.originalEvent.changedTouches[0].clientY - shuqian.touch.startY;
    		if (offsetY < -30) {
          var imgCount = $('.money img').length;
          $('.money img').eq(15).addClass('anim');
    			var neWImg = $("<img alt='rmb'>").attr('src', imgSrc);
    			$('.money').prepend(neWImg);

          shuqian.touch.currenImgId++;

          $(".money img:gt(30)").remove();

          if( shuqian.nowStatus == 'started')
          {
    			  shuqian.score++;
            $('.b_score').html( shuqian.score );
          }
    		}
        event.preventDefault();
    	});


}

/**
 * 显示结束排行榜
 * @param len
 */
shuqian.showResult = function () {

}

/**
 * 图片加载
 */
shuqian.loadImage = function(url, callbackFunc) {
    //创建一个Image对象，实现图片的预下载
    var img = new Image();
    img.src = url;

    // 如果图片已经存在于浏览器缓存，直接调用回调函数
    if (img.complete) {
        if (typeof callbackFunc == "function") {
            callbackFunc.call(img);
        }
        return;
    }

    img.onload = function () {
        if (typeof callbackFunc == "function") {
            //将回调函数的this替换为Image对象
            callbackFunc.call(img);
        }
    };
}

shuqian.finalRank = function ( game_players) {
  $.ajax({url: WechatMore.routes.final_rank_url, success:function(result){}});
  //game_players.forEach(function (v, i) {
  //      $('.player'+i+' .rank').html( v.rank );
  //      $('.player'+i+' .avatar').attr( 'src', v.avatar);
  //      $('.player'+i+' .nickname').html( v.nickname );
  //      $('.player'+i+' .score').html( v.score );
  //})
}
/**
 * 发送
 * @param url
 * @param params
 */
shuqian.fire = function(url, params)
{
  shuqian.channel.perform(url, params);
}
