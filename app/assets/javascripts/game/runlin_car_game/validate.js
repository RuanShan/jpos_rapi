// 手机号码验证
jQuery.validator.addMethod("cnmobile", function(value, element) {
    var length = value.length;
    var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
    return this.optional(element) || (length == 11 && mobile.test(value));
}, "请正确填写您的手机号码");


$(document).ready(function(){

     $("#j-game-player-form").validate({
       rules:{
      		'game_player[realname]':{
            required: true,
            rangelength:[2,10]
          },
      		'game_player[cellphone]':{
      			required:true,
            minlength: 11,
      			cnmobile:true
      		},
      },
      messages : {
        'game_player[cellphone]' : {
            required : "请输入手机号",
            minlength : "手机号11位",
            cnmobile : "请输入手机号"
        },
        'game_player[realname]' : {
            required : "请输入姓名",
            rangelength : "请输入完整姓名"
        },
      },
    //  errorPlacement: function(error, element) {
    //      $.toptip(error, 2000, 'error'); //error.appendTo(element.parent());
    //  }
   });
})
