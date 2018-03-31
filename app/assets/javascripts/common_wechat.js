//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require cable.js
//= require jquery.validate.min.js
//= require jquery.layermodel
//= require game/app_tool


$(document).ready(function(){

  if($('#sidebar').is('*'))
  {
    //$('#sidebar').sidr();
  }

  $('#b_show_award_list').click(function(){

    $.ajax({url: WechatMore.routes.final_rank_url, success:function(result){}});

    $(".poupInfoBox").show().removeClass("retrans").addClass("enlarge");
  })
  $('.poupClose').click(function(e){
    e.stopPropagation();
    e.preventDefault();
    $(".poupInfoBox").removeClass("enlarge").addClass("retrans").hide();
  })
});
