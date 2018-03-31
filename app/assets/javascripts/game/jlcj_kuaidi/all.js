//= require string.format
//= require jquery3
//= require turbolinks
//= require jquery.turbolinks
//= require jquery_ujs
//= require moment.min
//= require weui

var all_regexp = {
    IDNUM: /(?:^\d{15}$)|(?:^\d{18}$)|^\d{17}[\dXx]$/,
    MOBILE: /^1[0-9]{10}$/,
    VCODE: /^.{4}$/,
    IMGCODE: /^.{5}$/,
    PASSWORD: /[0-9a-zA-Z#@!~%^&*]{6,16}/
};
weui.form.checkIfBlur('#new_game_result_form', { regexp:all_regexp });

function fixDeliveryTimeOption()
{
  // 检查时间是否正确，
  // tonoon: 0, tonignt: 1, nenoon: 10, nenight: 11
  // 11:00以前 今中，今晚，明中
  // 11:00以后 今晚，明中，明晚
  // 17:00以后 明中，明晚
  // 00:00以后 今中，今晚，明中
  var now = moment();
  var $delivery_time_option = $( "input[name='game_result[delivery_time_option]']");
  var time_option = $delivery_time_option.val();
  console.log( now.toString());
  if(now.hours() <11)
  {
    // 23：59 -> 0：00点
    $('#game_result_delivery_time_option_tonoon').attr('disabled',false);
    $('#game_result_delivery_time_option_tonignt').attr('disabled',false);
    $('#game_result_delivery_time_option_nenoon').attr('disabled',false);
    $('#game_result_delivery_time_option_nenight').attr('disabled',true);
    var options = 'tonoon/tonignt/nenoon';
    if( options.indexOf(time_option ) <0 ){
      //选择今晚，禁止今中，允许明晚，
      $('#game_result_delivery_time_option_tonoon').attr('checked',true);
    }
  }else if( now.hours() >=11 && now.hours() <17)
  {
    // 10：59 -> 11：00点
    $('#game_result_delivery_time_option_tonoon').attr('disabled',true);
    $('#game_result_delivery_time_option_nenight').attr('disabled',false);
    var options = 'tonignt/nenoon/nenight';
    if( options.indexOf( time_option) <0 ){
      //选择今晚，禁止今中，允许明晚，
      $('#game_result_delivery_time_option_tonignt').attr('checked',true);
    }
  }else
  {
    // 16：59 -> 17：00点
    $('#game_result_delivery_time_option_tonignt').attr('disabled',true);
    $('#game_result_delivery_time_option_nenight').attr('disabled',false);
    var options = 'nenoon/nenight';
    if( options.indexOf( time_option) <0 ){
      //选择明中，禁止今晚，允许明晚，
      $('#game_result_delivery_time_option_nenoon').attr('checked',true);
    }
  }
}

$(document).ready(function(){
  var now = (new Date()).setTime( WechatMore.time*1000 );

  setInterval(fixDeliveryTimeOption, 1000 );

  $('#submitBtn').on('click', function(){

    weui.form.validate('#new_game_result_form', function (error) {
      if (!error) {
          var loading = weui.loading('提交中...');
          $.ajax({
            type: 'POST',
            url: WechatMore.routes.game_results_path ,
            data: $('#new_game_result_form').serialize(),
            complete: function(response){
              loading.hide();
              console.log( response);
              if( response.responseJSON.game_result)
              {
                var game_result = response.responseJSON.game_result;
                var template = '提交成功,您的{0}快递将于{1}送达寝室。';
                weui.toast( template.format( game_result.display_delivery_vendor, game_result.display_delivery_time_option ) , {
                  duration: 4000
                });
              }else {
                $('.weui-vcode-img').trigger('click');
                weui.topTips( '提交失败，请刷新页面重新填写。');
              }
            },
            dataType: 'json'});
      }else {
        //alert( error);
      }
    }, {
        regexp:all_regexp
    });
    return false;
  });

  $('.weui-vcode-img').on('click',function(){
    $(this).attr('src', WechatMore.routes.ru_captcha_path);
  })


})
