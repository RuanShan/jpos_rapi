// it is qiandao variation,
// show as simple as possible
var qiandao_asap = {
    sessionID: 0,
    companyID: 0,
    sID: 0,
    isTest: 1,
    //资源路径
    resPath: '',
    // 签到人员统计
    playerCount: 0,
    //当前进行状态
    nowStatus: 'created'
};

qiandao_asap.init = function () {

  qiandao_asap.channel = App.counting_game_channel = App.cable.subscriptions.create(
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
        var state = qiandao_asap.nowStatus = data.state;
        console.log( 'yes,red');
        App.debug( state);
        qiandao_asap.initUI();

        if( data.action == 'game_state')
        {
          qiandao_asap.load_players();
        }
        else if( data.action == 'next_player')
        {
          var game_player = data.game_player;
          qiandao_asap.showNewPlayer( game_player );
        }
        else if( data.action == 'prepare')
        {
          if( state == 'ready' )
          {
            location.href = WechatMore.routes.play_game_url;
          }else {
            console.error("sorry, can not convert game state to ready.")
          }
        }
        else if( data.action == 'rank')
        {
          //显示排名
          qiandao_asap.showRank(data.model);
        }
        // Called when there's incoming data on the websocket for this channel
      }
    }
  );
  //结束报名
  $('#b_check_over_game').click(function () {
    if(qiandao_asap.nowStatus != 'open'){
        return false;
    }
    qiandao_asap.fire('prepare' );
  });
  //重置游戏
  $('#b_reset_game').click(function () {
    qiandao_asap.fire('reset' );
  })
}

qiandao_asap.initUI = function(  ) {
  var state = qiandao_asap.nowStatus
  if( state == 'created' )
  {
    $('#b_check_over_game').hide();
    $('#b_start_game').hide();
    $('#b_check_over_game').hide();
  }

  if( state == 'open')
  {
    $('#b_check_over_game').show();
    $('#b_start_game').hide();
  }

  if( state == 'ready')
  {
    $('#b_check_over_game').hide();
    $('#b_start_game').show();
  }

  if( state == 'completed' )
  {
    $('#b_restart_game').show();
    $('#b_start_game').hide();
    $('#b_check_over_game').hide();
  }else {
    $('#b_restart_game').hide();
  }
  $('.b_player_count').html( qiandao_asap.playerCount);

}

qiandao_asap.checkState = function(){

  var checkStateInterval = setInterval(function () {
    qiandao_asap.fire('game_state');
    if(qiandao_asap.nowStatus != 'created')
    {
      clearInterval(checkStateInterval);
      location.reload();
    }
  }, 2000);

}

qiandao_asap.load_players = function(){
  var n = 0;
  qiandao_asap.playerCount = $('#b_players li').length;//0
  $('.b_player_count').html( qiandao_asap.playerCount);
console.log('yes, load players');
  var qiandao_asapInterval = setInterval(function () {

    if ( n< qiandao_asap.playerCount ) {
      // run each 0.5s
      $("#dh" + (n+1)).addClass('qiaodaosf');

      var div = document.getElementById('b_players');

      document.getElementById('b_players_container').scrollTop = div.scrollHeight;
    }else {
      if( qiandao_asap.nowStatus == 'open')
      {
        if (n%3==0)// run each 1.5s
        {
          qiandao_asap.fire('next_player', { position: qiandao_asap.playerCount })
        }
      }else {
         clearInterval(qiandao_asapInterval);
      }
    }
    n= n + 1;
    // update player count
    $('.b_player_count').html( qiandao_asap.playerCount);

  }, 500);
}
// 显示新签到的人员
qiandao_asap.showNewPlayer = function( game_player ){
  var user = game_player;
  if ( user && user.position > qiandao_asap.playerCount) {
    qiandao_asap.playerCount = user.position;

    var i = $('#b_players li').length + 1;

    var item = '<li id="dh' + i + '" class="qiaodaosf" ><img class="qiaodaotx"  id="hd' + i + '" src="' + user.avatar + '"><p id="nc' + i + '" class="qiaodaoxm">' + user.nickname + '</p><p id="qd' + i + '" class="qiaodaopm">' + user.position + '</p></li>';
    $('#b_players').append(item);
    var div = document.getElementById('b_players');
    document.getElementById('b_players_container').scrollTop = div.scrollHeight;

    $('.b_player_count').html( qiandao_asap.playerCount);

  }
}


/**
 * 发送
 * @param url
 * @param params
 */
qiandao_asap.fire = function(url, params)
{
    qiandao_asap.channel.perform(url, params);
}
