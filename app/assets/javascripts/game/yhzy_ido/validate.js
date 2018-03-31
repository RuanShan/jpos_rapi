// 手机号码验证
jQuery.validator.addMethod("cnmobile", function(value, element) {
    var length = value.length;
    var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
    return this.optional(element) || (length == 11 && mobile.test(value));
}, "请正确填写您的手机号码");


$(document).ready(function(){
  $("#j-wedding-photo-form").validate({
    rules:{
      'male[image]':{
        required: true
      },
      'game_player[realname]':{
        required: true,
        rangelength:[2,10]
      },
      'game_player[birth]':{
        required:true,
      },
      'female[image]':{
        required: true
      },
      'female[realname]':{
        required: true,
        rangelength:[2,10]
      },
      'female[birth]':{
        required:true,
      }
    },
    messages : {
      'game_player[realname]' : {
          required : "请输入他的姓名",
          minlength : "请输入他的正确姓名",
      },
      'game_player[birth]':{
        required : "请选择他的出生日期",
      },
      'male[image]':{
        date : "请选择他的照片",
      },
      'female[realname]' : {
          required : "请输入她的姓名",
          rangelength : "请输入她的正确姓名"
      },
      'female[birth]':{
        required : "请选择她的出生日期",
      },
      'female[image]':{
        required : "请选择她的照片",
      },
    },
    errorPlacement: function(error, element) {
         $.toptip(error, 2000, 'error'); //error.appendTo(element.parent());
    }
  });

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
          'game_player[birth(1i)]' :{
            required:true,
            min:1900,
            max:2017
          },
          'game_player[birth(2i)]' :{
            required:true,
            min:1,
            max:12
          },
          'game_player[birth(3i)]' :{
            required:true,
            min:1,
            max:31
          }
      	},
      messages : {
        'game_player[cellphone]' : {
            required : "请输入手机号",
            minlength : "手机号11位",
            cnmobile : "请输入手机号"
        },
        'game_player[realname]' : {
            required : "请输入姓名",
            rangelength : "请输入姓名"
        },
        'game_player[birth(1i)]':{
          required : "请输入出生年月日",
          min: '请输入正确年份',
          max: '请输入正确年份'
        },
        'game_player[birth(2i)]':{
          required : "请输入出生年月日",
          min:'请输入1-12月份',
          max:'请输入1-12月份'
        },
        'game_player[birth(3i)]':{
          required : "请输入出生年月日",
          min:'请输入1-31日',
          max:'请输入1-31日'
        },
      },
      errorPlacement: function(error, element) {
          $.toptip(error, 2000, 'error'); //error.appendTo(element.parent());
      }
   });
})
