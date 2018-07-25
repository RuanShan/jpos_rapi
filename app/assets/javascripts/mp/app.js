$( "document" ).on( "click", "#get_verify_code", function( event ) {
  console.log( " document.click button#get_verify_code")


  var node = this;
  //发短信按键
      var	$mobile = $("input[name=wx_follower[mobile]]");
      weui.form.validate('.new_wx_follower', function (error) {
        if (!error) {
          _.getVerifyCode({
                        disabled:"重新获取",
                        text:"重新发送",
                        time:60,
                        sendHint:true,
                        sendText:"动态验证码已发送到您的手机，10分钟内有效",
                        ctx: node,
                        auth:{
                          url: Jpos.routes.get_sms_code_url,
                          data:{
                            "mobile": $mobile.val(),
                          }
                        }
                      });
                    }
                  });

});
