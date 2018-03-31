/* global $:true */
+function ($) {
  "use strict";

  var ITEM_ON = "weui-bar__item--on";

  var showTab = function(a) {
    var $a = $(a);
    if($a.hasClass(ITEM_ON)) return;
    var href = $a.attr("href");

    if(!/^#/.test(href)) return ;

    $a.parent().find("."+ITEM_ON).removeClass(ITEM_ON);
    $a.addClass(ITEM_ON);

    var bd = $a.parents(".weui-tab").find(".weui-tab__bd");

    bd.find(".weui-tab__bd-item--active").removeClass("weui-tab__bd-item--active");

    $(href).addClass("weui-tab__bd-item--active");
    //如果tab页面中有 loading image, ajax加载内容, 成功后删除loading

      if(href == '#rankingTab')
      {
        $.get( WechatMore.routes.ranking_game_round_path, function(){
          $(href).find('.loading').remove();
        })
      }else if (href == '#resultTab')
      {
        $.get( WechatMore.routes.result_game_round_path, function(){
          $(href).find('.loading').remove();
        })

      }else if (href == '#awardsTab')
      {
        $.get( WechatMore.routes.awards_game_round_path, function(){
          $(href).find('.loading').remove();
        })
      }

  }

  $.showTab = showTab;

  $(document).on("touchstart", ".weui-navbar__item, .weui-tabbar__item", function(e) {
    var $a = $(e.currentTarget);
    var href = $a.attr("href");
    if($a.hasClass(ITEM_ON)) return;
    if(!/^#/.test(href)) return;

    e.preventDefault();

    showTab($a);
  });

}($);
