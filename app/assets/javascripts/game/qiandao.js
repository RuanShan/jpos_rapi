var qiandao = {
    sessionID: 0,
    companyID: 0,
    //检测游戏状态的定时器，主要检测游戏是否开始
    checkStateIntervalID: 0,
    isTest: 1,
    //资源路径
    resPath: '',
    // 签到人员统计
    playerCount: 0,
    //当前进行状态
    nowStatus: 'created'
};

qiandao.init = function () {

  qiandao.channel = App.counting_game_channel = App.cable.subscriptions.create(
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
        var state = qiandao.nowStatus = data.state;
        App.debug( state);
        qiandao.initUI();

        if( data.action == 'game_state')
        {
          if( state == 'created')
          {
            if( qiandao.checkStateIntervalID == 0)
            {
              qiandao.checkState();
            }
          }

          if( state == 'open'  )
          {
            qiandao.showSignedPlayers();
          }
        }
        else if( data.action == 'next_player')
        {
          var game_player = data.game_player;
          qiandao.showNewPlayer( game_player );
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
          qiandao.showRank(data.model);
        }
        else if( data.action == 'load_players')
        {
          //显示排名
          qiandao.loadPlayers(data.model);
        }
        // Called when there's incoming data on the websocket for this channel
      }
    }
  );
  //结束报名
  $('#b_check_over_game').click(function () {
    if(qiandao.nowStatus != 'open'){
        return false;
    }
    qiandao.fire('prepare' );
  });
  //重置游戏
  $('#b_reset_game').click(function () {
    qiandao.fire('reset' );
  })
}

qiandao.initUI = function(  ) {
  var state = qiandao.nowStatus
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
  }else {
    $('#b_restart_game').hide();
  }
  $('.b_player_count').html( qiandao.playerCount);

}
qiandao.checkState = function(){

  qiandao.checkStateIntervalID = setInterval(function () {
    qiandao.fire('game_state');
    if(qiandao.nowStatus != 'created')
    {
      clearInterval(checkStateIntervalID);
      location.reload();
    }
  }, 2000);

}
qiandao.showSignedPlayers = function(){
  var n = 0;
  qiandao.playerCount = $('#b_players li').length;//0
  $('.b_player_count').html( qiandao.playerCount);

  var qiandaoInterval = setInterval(function () {

    if ( n< qiandao.playerCount ) {
      // run each 0.5s
      $("#dh" + (n+1)).addClass('qiaodaosf');

      var div = document.getElementById('b_players');

      document.getElementById('b_players_container').scrollTop = div.scrollHeight;
    }else {
      if( qiandao.nowStatus == 'open')
      {
        if (n%3==0)// run each 1.5s
        {
          qiandao.fire('next_player', { position: qiandao.playerCount })
        }
      }else {
         clearInterval(qiandaoInterval);
      }
    }
    n= n + 1;

  }, 500);
}
// 显示新签到的人员
qiandao.showNewPlayer = function( game_player ){
  var user = game_player;
  if ( user && user.position > qiandao.playerCount) {
    qiandao.playerCount = user.position;

    var i = $('#b_players li').length + 1;

    $("#qdtx").attr("src", user.avatar);
    $("#qdnums").html(user.position);
    $("#qdname").html(user.nickname);
    $(".tuchu").addClass('view');

    setTimeout(function() {
      var item = '<li id="dh' + i + '" class="qiaodaosf" ><img class="qiaodaotx"  id="hd' + i + '" src="' + user.avatar + '"><p id="nc' + i + '" class="qiaodaoxm">' + user.nickname + '</p><p id="qd' + i + '" class="qiaodaopm">' + user.position + '</p></li>';
      $('#b_players').append(item);
      var div = document.getElementById('b_players');
      document.getElementById('b_players_container').scrollTop = div.scrollHeight;
    },
    7000);

  }
}


/**
 * 发送
 * @param url
 * @param params
 */
qiandao.fire = function(url, params)
{
    qiandao.channel.perform(url, params);
}
