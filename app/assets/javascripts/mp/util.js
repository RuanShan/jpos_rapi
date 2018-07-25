(function(window) {
	var _ = { //通用的方法类
    //倒计时
    getTime: function(i, that, fn, num) { // i : 从哪个时间开始倒计时, that : 哪个对象进行显示时间 , fn : 倒计时要执行的函数, num: 延时
      that.text(i);
      var time = setInterval(function() {
        that.text(--i);
        i <= 0 ? (
          $.isFunction(fn) ? fn() : null,
          clearInterval(time),
          time = null
        ) : null;
      }, num || 1000);

      time;
    },
    validataSmsCode:function(obj) {//验证手机验证码
        var data = {
            "activate": obj.activate,
            "type": obj.type,
            "phone": obj.phone
          };

      $.ajax({
        url: ctx + "/sms/validataSmsCode",
        data: data,
        type: "POST",
        dataType: "json",
        success: function(data){
          obj.fn(data);
        },
        error:function(xhr, error, msg){
          console.info(msg);
        }
      });
    },
    getVerifyCode:function( obj ){
      $(obj.ctx)
        .html("<span class='time'></span>s后" + obj.disabled + "")
        .prop("disabled", true);

      hal.getTime(obj.time, $(".time"), function() {
        $(obj.ctx).html(obj.text).prop("disabled", false);
      });

      $.post(obj.auth.url, obj.auth.data, function(response){
				console.debug(response );
				if( response.status ==1 )
				{
					weui.toast('验证短信已发送！',2000);
				}	else{
					weui.alert('短信发送失败，请联系客服！');
				}
			},"json");
    },
    //倒计时
    setInterval:function(time, fn, num){
      var count_Down,
        times;
      setTimeout(function(){
        count_Down = $.isFunction(fn) && fn();
      },1000);
      times = setInterval(function(){
          var leftTime = hal.countDown(time, count_Down);
          if(!leftTime){
            clearInterval(times);
          }
      }, num||1000);
    },
    countDown:function(time, count_Down){
      var EndTime= new Date(parseInt(time, 10)),
          NowTime = new Date(),
          leftTime = EndTime.getTime() - NowTime.getTime(),
          leftsecond = parseInt(leftTime/1000, 10),
          day = hal.day(leftsecond),
          hour = hal.hour(leftsecond),
          minute = hal.minute(leftsecond),
          second = hal.second(leftsecond),
          getTime = day + hour + minute + second;

        getTime ? count_Down.html(getTime) : count_down.parent().remove() ;

          return leftTime;
    },
    checkTime : function(time){//1-9的时候前面加0
      if(time < 10){
        time = "0" + time;
      }
      return time;
    },
    day:function(time){
       var day = parseInt(time / 60 / 60 / 24, 10);//计算剩余的天数
               if(day > 0){
                 day = day + "天";
               }else{
                 day = "";
               }
               return day;
    },
    hour:function(time){
       var hour = parseInt(time / 60 / 60 % 24, 10);//计算剩余的小时数
       if(hour > 0){
                hour = hal.checkTime(hour) + "小时";
       }else{
         hour = "";
               }
               return hour;
    },
    minute:function(time){
        var minute = parseInt(time / 60 % 60, 10);//计算剩余的分钟数
        if(minute > 0){
          minute = hal.checkTime(minute) + "分钟";
        }else{
          minute = "";
            }
               return minute;
    },
    second:function(time){
       var second = parseInt(time % 60, 10);//计算剩余的秒数
       if(second > 0){
                 second = hal.checkTime(second) + "秒";
       }else{
         second = "";
            }
               return second;
    }
  },
  hal = _;
	window._ = _;
})(window);
