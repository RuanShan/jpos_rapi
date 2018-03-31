App.counting_game_channel = App.cable.subscriptions.create(
  {
    channel:"GameRoundChannel",
    game_round_id: WechatMore.game_round_id,
    terminal: WechatMore.terminal,
    openid: WechatMore.openid
  },
  {
    connected: function() {
      // Called when the subscription is ready for use on the server
      this.game_state();
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {
      console.debug( data)
      if( data.action == 'game_state')
      {
        var game_round = data.model;
        if( game_round.state == 'ready' )
        {

        }
        else if( game_round.state == 'countdown' )
        {

          var start_at = moment( game_round.start_at );

        }
        else if( game_round.state == 'started' )
        {

        }
      }
      // Called when there's incoming data on the websocket for this channel
    },
    game_state: function()
    {
        return this.perform('game_state');
    },

    prepare_game: function( game_round )
    {

    },
    start_game: function( game_round )
    {

    }
  }
)
