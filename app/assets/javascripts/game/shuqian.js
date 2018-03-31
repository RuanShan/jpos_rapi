/**
 * Created by zxywx on 2016/10/24.
 */
shuqian = {
    check_in_url:'',
    play_url:'',
    //倒计时时间
    cd: 0,
    //计数倒计时时间
    nowCd: 0,
    //资源路径
    resPath: '',
    //当前进行状态
    nowStatus: 'created',
    players: []
};

/**
 * 初始化
 * @param e
 */
shuqian.init = function () {
  shuqian.check_in_url = WechatMore.routes.check_in_game_url;
  shuqian.play_url = WechatMore.routes.play_game_url;

  shuqian.channel = App.counting_game_channel = App.cable.subscriptions.create(
    {
      channel:"GameRoundChannel",
      game_round_id: WechatMore.game_round_id,
      terminal: WechatMore.terminal,
      game_player_id: WechatMore.game_player_id
    },
    {
      connected: function() {
        // Called when the subscription is ready for use on the server
        this.perform('game_state');
      },

      disconnected: function() {
        setTimeout(function () {
            location.reload();
        }, 2000);
      },

      received: function(data) {
        var now = new Date(data.now);
        var game_round = data.game_round;
        var state = shuqian.nowStatus = data.state;
        var nowCd = shuqian.nowCd = data.seconds;
        App.debug( state+'-'+ data.action + '-'+nowCd );
        // 同步指令需要跳过，否则initUI会根据当前状态再次发出同步指令
        if( data.action == 'sync_cd' )
        {
          shuqian.syncCountdown( );
        }else {
          shuqian.initUI( game_round );
        }
        if( data.action == 'game_state')
        {
          if( state == 'ready' )
          {
          }
          else if( state == 'starting' )
          {
            shuqian.nowCd = data.seconds;
            shuqian.startCountDown(shuqian.nowCd );
          }
          else if( state == 'started' )
          {
            shuqian.nowCd = data.seconds;
            shuqian.endCountDown(shuqian.nowCd );
            //排名.
            shuqian.fire('rank');
            shuqian.rankData();
            //shuqian.audioBgm.play();
          }else if( state == 'completed' ){
            //shuqian.fire('rank', { "type": 'final' });
          }
        }
        else if( data.action == 'restart' || data.action == 'reset')
        {
           window.location= shuqian.check_in_url;
        }
        else if( data.action == 'count_down')
        {
          if( state == 'starting')
          {
            shuqian.nowCd = data.seconds;
            shuqian.startCountDown(shuqian.nowCd );
          }
        }
        else if( data.action == 'start')
        {
          if( state == 'started')
          {
            shuqian.nowCd = data.seconds;
            shuqian.endCountDown(shuqian.nowCd );
            //排名.
            shuqian.fire('rank' );
            shuqian.rankData();
          }
        }
        else if( data.action == 'rank')
        {
          //显示排名
          shuqian.showRank(data.game_players);
        }else if( data.action == 'complete')
        {
          shuqian.fire('rank', { "type": 'final' });
        }
        else if( data.action == 'final_rank')
        {
          //显示排名
          $.ajax({url: WechatMore.routes.final_rank_url, success:function(result){}});

          //显示排名popup
          shuqian.finalRank(data.game_players);
        }
      }
    }
  )

    //资源加载
    shuqian.audioBgm = document.querySelector('#audio');

    //开始游戏 按键
    $(document).keydown(function (e) {
        if (e.keyCode == 13) {
            $('#b_start_game').click();
        }
    });

    //结束报名
    $('#b_check_over_game').click(function () {
      if(shuqian.nowStatus != 'open'){
          return false;
      }
      shuqian.fire('prepare' );
    });

    //开始游戏
    $('#b_start_game, #b-start-game').click(function () {
        if(shuqian.nowStatus != 'ready'){
            return false;
        }
        shuqian.fire('count_down' );
    });

    //再来一次
    $('#b_restart_game').click(function () {
       shuqian.fire('restart');
    });

    //重置游戏
    $('#b_reset_game').click(function () {
      shuqian.fire('reset' );
    })
    $('#b_final_close').click(function(){
      $('#final').fadeOut();
    })
};
// game_round: json
// now is server time
shuqian.initUI = function( game_round ) {
  var state = shuqian.nowStatus
  if( state == 'created' )
  {
    $('#b_start_game').hide();
    $('#b_check_over_game').hide();
    $('#waiting').show();
    $('#game').hide();
    $('#game-result').hide();
  }else if( state == 'open')
  {
    $('#b_check_over_game').show();
    $('#b_restart_game').hide();

  }else  if( state == 'ready')
  {
    $('#b_check_over_game').hide();
    $('#b_start_game').show();
    $('#b_restart_game').hide();
    $('#waiting').show();
    $('#game').hide();
    $('#game-result').hide();
    $('.b_game .b_title.ready').show().siblings().hide();
  }
  if( state == 'starting')
  {
    $('.b_cover').show();
    $('.b_countdown').show();

    $('#game').show();
    $('#waiting').hide();
    $('#game-result').hide();
    $('.b_game .b_title.starting').show().siblings().hide();
  }
  if( state == 'started')
  {
    $('.b_countdown').hide();
    $('.b_cover').hide();

    $('#game').show();
    $('#waiting').hide();
    $('.b_game .b_title.started').show().siblings().hide();
  }

  if( state == 'completed' )
  {
    $('#b_restart_game').show();
    $('#b_check_over_game').hide();
    $('#b_start_game').hide();
    $('#waiting').hide();
    $('#game').hide();
    $('#game-result').show();
    $('.b_heading .b_name').html(  WechatMore.game_rount_name );
  }
  $('.b_player_count').html( shuqian.playerCount);
};

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
    $('.b_heading .b_name').html( '距本轮结束还剩:'+nowCd+'秒');
    if( nowCd == 0)
    {
      //当前活动状态
      shuqian.nowStatus = 'completed';
      shuqian.fire('complete' );
    }
  }
}

/**
 * Message
 * @param e
 */
shuqian.onmessage = function (e) {
    var data = JSON.parse(e.data);
    console.log(data);
    if (undefined != data.msg && 'ok' != data.msg) {
        alert('数据未获取，请尝试刷新后重试');
        return ;
    }

    //绑定屏幕
    if(data.url == 'shuqian/login'){
        shuqian.fire('shuqian/bind_screen', { "company_id": shuqian.companyID, "sid": shuqian.sID });
    };

    //当前进度
    if(data.url == 'shuqian/progress'){
        var nowInfo = data.body;

        if(nowInfo.progress == 2){

            $('#game').show();
            $('#waiting').hide();
            //倒计时
            shuqian.countDown(nowInfo.cd);
            //排名.
            shuqian.fire('shuqian/rank', { "sid": shuqian.sID });
            shuqian.rankData();
            shuqian.audioBgm.play();
        }else if(nowInfo.progress == 3){
            shuqian.fire('shuqian/rank', { "company_id": shuqian.companyID, "sid": shuqian.sID, "type": 'final' });
        }
    }

    //最终排名
    if(data.url == 'shuqian/final_rank'){
        var final = data.body;

        if(final !== null){

        }

        //显示结果
        $('#game-result').show();
        $('#game').hide();
    }

    //有提示的失败操作
    if(data.url == 'shuqian/error'){
        alert(data.params);
    }

    //没有
    if(data.url == 'shuqian/not_create'){
        $('#not-create').show();
    }
}

/**
 * 开始前的倒计时
 * @param nowCd
 */
shuqian.startCountDown = function (nowCd) {

    var cd = nowCd;

    var shuqianInterval = setInterval(function () {
        shuqian.fire('sync_cd', { "cd":cd });
        cd--;
        if(cd < 0){
            //倒数计时结束
            clearInterval(shuqianInterval);
            //当前活动状态
            //shuqian.nowStatus = 'started';
            shuqian.fire('start');

         }
    }, 1000);
}


/**
 * 结束倒计时
 * @param nowCd
 */
shuqian.endCountDown = function (nowCd) {
    if(nowCd !== undefined){
        var cd = nowCd;
    }else{
        var cd = shuqian.cd;
    }
    $('.b_game .b_title.started span').text(cd);
    var shuqianInterval = setInterval(function () {
        shuqian.fire('sync_cd', { "cd":cd });
        //shuqian.fire('rank');
        cd--;
        if(cd < 0){
            //shuqian.audioBgm.pause();
            //倒数计时结束
            clearInterval(shuqianInterval);
            //清除排名获取任务
            clearInterval(shuqian.getRankData);
        }
    }, 1000);
}

/**
 * 获取排名数据
 */
shuqian.rankData = function () {
    shuqian.getRankData = setInterval(function () {
        shuqian.fire('rank', { "sid": shuqian.sID });
    }, 1000);
}

/**
 * 动态显示排名
 * @param r [player_id, score]
 */
shuqian.showRank = function (r) {
    if(r != undefined){
        r.forEach(function ( v, i) {
          //console.info( v);

            if((i+1) > 7){
                return false;
            }

            var userRankNow = $('#user-rank li[data-id="'+v.id+'"]');

            //用户列表动态更新 现在是否存在
            if(userRankNow.length == 0){
                var nowRankExist = $('#user-rank li[rank="'+(i+1)+'"]');

                if(nowRankExist.length > 0){
                    nowRankExist.attr({ 'rank': (i+1), 'data-id': v.id });
                    nowRankExist.find('img').attr('src', v.avatar);
                    nowRankExist.find('.name').text(v.nickname);
                    nowRankExist.find('.rank').html(v.score);
                }else{
                    var userRankHtml = '<li data-id="'+v.id+'" rank="'+(i+1)+'" class="pos'+(i+1)+'">'+
                        '    <p class="rank">'+v.score+'</p>'+
                        '    <div class="ava"><img src="'+v.avatar+'"></div>'+
                        '    <p class="name">'+v.nickname+'</p>'+
                        '</li>';
                    $('#user-rank').append(userRankHtml);
                }

            }else{
                var nowRank = userRankNow.attr('rank');
                if(nowRank != (i+1)){
                    userRankNow.attr({ 'rank': (i+1), 'class': 'pos'+(i+1) });
                }
                userRankNow.find('.rank').html(v.score);
            }

            var goldRankNow = $('#gold-rank li[data-id="'+v.id+'"]');

            //金币列表动态更新
            if(goldRankNow.length == 0){
                var nowGoldRankExist = $('#gold-rank li[rank="'+(i+1)+'"]');

                if(nowGoldRankExist.length > 0){
                    nowGoldRankExist.remove();
                }

                var goldRankHtml = '<li data-id="'+v.id+'" rank="'+(i+1)+'" class="level'+(i+1)+'"></li>'
                $('#gold-rank').append(goldRankHtml);
            }else{
                var maxTouchNum = shuqian.cd * 8;
                var aNumGoldNum = (maxTouchNum / 17).toFixed();
                //换算当前用户的金币数量
                var userGoldNum = (v.score / aNumGoldNum).toFixed();
                //当前页面的金币数量
                var nowGoldNum = $('#gold-rank li[data-id="'+v.id+'"]').find('em').length;

                //如果已经超过了最大数量，只显示17个
                if(v.score >= maxTouchNum && nowGoldNum == 0){
                    shuqian.addGold(17, v.id);
                }else if(nowGoldNum < 17 && nowGoldNum < userGoldNum){
                    var needNum = userGoldNum - nowGoldNum;
                    shuqian.addGold(needNum, v.id);
                }

                //更新页面排名
                var nowGoldRank = goldRankNow.attr('rank');
                if(nowGoldRank != (i+1)){
                    goldRankNow.attr({ 'rank': (i+1), 'class': 'level'+(i+1) });
                }
            }
        })
    }
}
shuqian.finalRank = function ( game_players) {
  // 1920*1200
  //
  var body_width = parseInt($(window).width());
  var body_height = parseInt($(window).height());
  var screen_ratio = body_height/body_width;
  var image_ratio = 1200/1920;
  //background-size:cover
  var h = 1200;
  var w = 1920;
  if ( screen_ratio>image_ratio )
  {// 屏幕高宽比>图片高宽比，图片长度部分会被遮住
    var w = 1200/screen_ratio;
  }else{// 屏幕高宽比<图片高宽比，图片高度部分会被遮住
    var h = 1920*screen_ratio;
  }

  var p0p1x = 405; //p1 p2 中心矩
  var p0p2x = 425; //p1 p3 中心矩
  var y0p0y = 720; //原图 p0位置高度
  var y0p1y = 640;//原图 p1位置高度
  var y0p2y = 600;//原图 p2位置高度
  var p1x = body_width/2 - p0p1x * body_width/w  -70
  var p2x = body_width/2 + p0p2x * body_width/w  -70
  var p0y = y0p0y * body_height/h  -70
  var p1y = y0p1y * body_height/h  -70
  var p2y = y0p2y * body_height/h  -70

  //  屏幕高，图片上部有部分隐藏
  $('.final_player0').css( { bottom: p0y} );
  $('.final_player1').css( { left: p1x, bottom: p1y} );
  $('.final_player2').css( { left: p2x, bottom: p2y} );
  // 先设置分数。
  game_players.forEach(function (v, i) {
    $('.final_player'+i+' .avatar').attr( 'src', v.avatar);
    $('.final_player'+i+' .nickname').html( v.nickname );

        $('.player'+i+' .rank').html( v.rank );
        $('.player'+i+' .avatar').attr( 'src', v.avatar);
        $('.player'+i+' .nickname').html( v.nickname );
        $('.player'+i+' .score').html( v.score );
  })
  $('#final').fadeIn();


}
/**
 * 添加金币
 * @param num
 * @param classNum
 */
shuqian.addGold = function (num, id) {
    for(var i = 0; i < num; i++){
        var randNum = parseInt(Math.random()*2)+1;
        var goldHtml = '<em class="drop'+randNum+'"></em>';
        $('#gold-rank li[data-id="'+id+'"]').prepend(goldHtml);
    }
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
