//= require game/choujiang
//= require game/shuqian


$(document).ready(function(){


  if( $(".check_in_play").is("*"))
  {
    choujiang.playerCount=WechatMore.game_player_count;
    choujiang.init();
  }
  if( $(".counting_play").is("*"))
  {
    shuqian.playerCount=WechatMore.game_player_count;
    shuqian.cd = WechatMore.game_countdown;
    shuqian.init();
  }

});
