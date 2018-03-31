//$(document).on("WeixinJSBridgeReady", function () {
//    WechatMore.bgMp3();
//});
wx.ready(function () {
  WechatMore.bgMp3();
  fixShareLink();
});

function fixShareLink()
{
  wx.onMenuShareTimeline({
    title:  WechatMore.shareData.desc,
    desc:WechatMore.shareData.title,
    link:   getShareLink(),
    imgUrl: WechatMore.shareData.imgUrl,
    success: function () {
            },
    cancel: function () {
    }
  });
  wx.onMenuShareAppMessage({
    title: WechatMore.shareData.title,
    desc: WechatMore.shareData.desc,
    link:  getShareLink(),
    imgUrl: WechatMore.shareData.imgUrl,
    type: '',
    dataUrl: '',
    success: function () {
    },
    cancel: function () {
    }
  });
}

function getShareLink()
{
  var link = ''
  if( WechatMore.game_code == "yhzy_jhj" )//结婚照分享
  {
    link = WechatMore.routes.shared_game_round_url+ '?step='+ WechatMore.step+'&player_id='+WechatMore.game_player_by_openid;
  }else{ //积攒分享
    //如果注册了，发自己的分享链接，
    if( WechatMore.game_player_by_openid >0 )
    {
      link = WechatMore.routes.shared_game_round_url+ '?step=6&player_id='+WechatMore.game_player_by_openid;
    }else if(  WechatMore.game_player_id >0 )
    {
      link = WechatMore.routes.shared_game_round_url+ '?step=6&player_id='+WechatMore.game_player_id;
    }else{
      link = WechatMore.routes.shared_game_round_url + '?step='+ WechatMore.step
    }
  }
  console.log( 'link'+link);
  return link;

}
