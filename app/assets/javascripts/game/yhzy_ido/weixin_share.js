
// 所有功能必须包含在 WeixinApi.ready 中进行
WeixinApi.ready(function(Api){

    // 微信分享的数据
    var wxData = {};
    $.extend(wxData, WechatMore.shareData);

    // 分享的回调
    var wxCallbacks = {
        // 分享操作开始之前
        ready:function () {
            // 你可以在这里对分享的数据进行重组
            //wxData.imgUrl ='http://ido.zhuhemedia.com/share.jpg';
            if( WechatMore.step == 11)//结婚照分享
            {
              wxData.link = WechatMore.routes.shared_game_round_url+ '?step='+ WechatMore.step+'&player_id='+WechatMore.game_player_by_openid;
              wxData.imgUrl = WechatMore.shareData.imgUrl;
            }else{ //积攒分享
              if( WechatMore.game_player_by_openid >0 )
              {
                wxData.link = WechatMore.routes.shared_game_round_url+ '?step=6&player_id='+WechatMore.game_player_by_openid;
              }else if(  WechatMore.game_player_id >0 )
              {
                wxData.link = WechatMore.routes.shared_game_round_url+ '?step=6&player_id='+WechatMore.game_player_id;
              }else{
                wxData.link = WechatMore.routes.shared_game_round_url + '?step='+ WechatMore.step
              }
              wxData.imgUrl = WechatMore.shareData.imgUrl;

            }
        },
        // 分享被用户自动取消
        cancel:function (resp) {
            // 你可以在你的页面上给用户一个小Tip，为什么要取消呢？
        },
        // 分享失败了
        fail:function (resp) {
          console.log(resp);
            // 分享失败了，是不是可以告诉用户：不要紧，可能是网络问题，一会儿再试试？
        },
        // 分享成功
        confirm:function (resp) {
            // 分享成功了，我们是不是可以做一些分享统计呢？
        },
        // 整个分享过程结束
        all:function (resp) {
            // 如果你做的是一个鼓励用户进行分享的产品，在这里是不是可以给用户一些反馈了？
        }
    };

    // 用户点开右上角popup菜单后，点击分享给好友，会执行下面这个代码
    Api.shareToFriend(wxData, wxCallbacks);

    // 点击分享到朋友圈，会执行下面这个代码
    Api.shareToTimeline(wxData, wxCallbacks);

    // 点击分享到腾讯微博，会执行下面这个代码
    Api.shareToWeibo(wxData, wxCallbacks);
});
