//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.countdown
//= require cable.js
//= require layer.js
//= require game/jquery.ext
//= require game/base
//= require game/qiandao
//= require game/qiandao_asap


$(document).ready(function(){
	//
	$("#show_hide_nav img").on('click',function() {
  	if(WechatMore.panelState == 'closed'){
      $(".Panel.Top").css({
          top: 0
      });
      $(".Panel.Bottom").css({
          bottom: 0
      })

      $(this).hide();
      $('#show_hide_nav .b_opened_image').show();
  		WechatMore.panelState = 'opended';
  	}else{

      $(".Panel.Top").css({
          top: "-" + $(".Panel.Top").height() + "px"
      });
      $(".Panel.Bottom").css({
          bottom: "-" + $(".Panel.Bottom").height() + "px"
      });

      WechatMore.panelState = 'closed';
      $(this).hide();
      $('#show_hide_nav .b_closed_image').show();

  	}
	});


	// 签到
  if( $(".game.check_in").is("*"))
  {
    if( WechatMore.game_code == 'check_in')
    {
      qiandao.init();
    }
    if( WechatMore.game_code == 'counting')
    {
      qiandao_asap.init();
    }
  }
});
