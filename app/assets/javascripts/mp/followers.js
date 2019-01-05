// 取得验证码
$(document).on("click", "#b_get_verify_code", function(event) {
  console.log(" document.click button#get_verify_code")

  var node = this;
  //发短信按键
  var mobile_selector = "input[name='wx_follower[mobile]']";
  var $mobile = $(mobile_selector);
  var valid = Jpos.wx_follower_validator.element(mobile_selector)
  console.log( 'valid=',valid)
  //weui.form.validate('.new_wx_follower', function(error) {
    if (valid) {
      _.getVerifyCode({
        disabled: "重新获取",
        text: "重新发送",
        time: 60,
        sendHint: true,
        sendText: "动态验证码已发送到您的手机，10分钟内有效",
        ctx: node,
        auth: {
          url: Jpos.routes.get_sms_code_url,
          data: {
            "mobile": $mobile.val(),
          }
        }
      });
    }
  //});
});

// 提交关联客户
//$(document).on("click", "#b_associate_customer", function(event) {
//  event.preventDefault();
//  console.log(" document.click button#b_associate_customer")
//  var valid = Jpos.wx_follower_validator.form();
//  if (valid) {
//    $.ajax({
//      url:Jpos.routes.associate_wx_follower_to_customer_url,
//      type: "POST",
//      dataType: "json",
//      data:  $(".new_wx_follower").serialize(),
//      success: function(res){
//        console.log(" document.click button#b_associate_customer success", res)
//      }
//    })
//  }
//});




$(document).on("turbolinks:load", function() {
  console.log('document.ready turbolinks:load')
  var wx_follower_validator = $(".new_wx_follower").validate({
    onkeyup:false,
    rules: {
      'wx_follower[mobile]': {
        required: true,
        rangelength:[11,11],
        remote: {
          url: Jpos.routes.validate_wx_follower_mobile_url, //后台处理程序
          dataType: "json", //接受数据格式
          async:false, // 设置为同步，否则validate返回结果没有同步
          data: { //要传递的数据
            mobile: function() {
              return $("#wx_follower_mobile").val();
            }
          }
        }
      },
      'wx_follower[verify_code]': {
        required: true,
        rangelength:[4,6] // 短信验证码有时是5位，有时6位
      },

    },
    messages: {
      'wx_follower[mobile]': {
        required: "请输入手机号码",
        rangelength: "手机号码由11个数字组成",
        remote: "客户手机号码不存在，请咨询门店"
      },
      'wx_follower[verify_code]': {
        required: "请输入短信验证码",
        rangelength: "请输入4-6位短信验证码"
      },
    },
    showErrors:function(errorMap,errorList) {
      if( errorList.length>0){
        var error= errorList[0]
        console.log( "errorList=", errorMap, errorList, error )
        //https://github.com/Tencent/weui.js/blob/master/docs/component/form.md#showErrorTips
        weui.form.showErrorTips({ele:error.element, msg: error.method})
      }
    }
  })
  Jpos.wx_follower_validator = wx_follower_validator;


});
