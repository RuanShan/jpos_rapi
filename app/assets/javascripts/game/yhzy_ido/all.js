//= require jquery-2.1.4.min
//= require jquery.validate.min
//= require createjs/soundjs.min
//= require swiper-3.4.2.min
//= require lrz.all.bundle
//= require jquery-weui.min
//= require jquery.loading
//= require layer.custom
//= require game/yhzy_ido/dpicker
// require game/yhzy_ido/weixin_api
//= require game/yhzy_ido/touch-0.2.14.js
//= require game/yhzy_ido/game
//= require game/yhzy_ido/messages_zh
//= require game/yhzy_ido/validate
//= require game/yhzy_ido/weixin

(function ($) {
    var defaults = {
        classIn: 'moveIn',
        classOut: 'moveOut',
        onClass:'page-on',
        complete: function () { }
        // CALLBACKS
    };
    $.fn.moveIn = function (options) {
        var options = $.extend({},defaults, options);
        this.addClass(options.classIn).show();
        this.one('webkitAnimationEnd', function () {
            $(this).removeClass(options.classIn).addClass(options.onClass);
            options.complete();
        });
        return this;
    }
    $.fn.moveOut = function (options) {
        var options = $.extend({},defaults, options);
        this.addClass(options.classOut).show();
        this.one('webkitAnimationEnd', function () {
            $(this).removeClass(options.classOut+' '+options.onClass).hide();
            options.complete();
        });
        return this;
    }
})(jQuery);

var WechatMore = WechatMore || { fn:{} };

WechatMore.fn.hint=function(text){
    //提示层
    var box=$('#js_hint');
    box.html(text).moveIn();
    if(box[0].timer) {
        clearTimeout(box[0].timer);
    }
    box[0].timer=setTimeout(function(){
        box.moveOut();
    },2000);
}

//公用模块
//上传照片
WechatMore.fn.previewImage=function(target, num){
        var file = target.files[0];
        if (!/image\/\w+/.test(file.type)) {
            _ll.hint('上传文件必须为图片');
            return false;
        }
        lrz(file, {
            width: 640,
            quality: 0.6
        })
        .then(function (rst) {
            if (num == 0) {
                _g.base64_One = rst.base64;
                $("#j-photo-1").attr("src", rst.base64);
            }
            if (num == 1) {
                _g.base64_Two = rst.base64;
                $("#j-photo-2").attr("src", rst.base64);
            }
        });
}
var _g={
    base64_One: null, // left 图片
    base64_Two: null, //right 图片
    type: -1, // 选择类型
    similarity: null, // 相似度
};
//模块功能  // 上传图片
WechatMore.fn.upload = function(complete){
        if(!_g.base64_One || !_g.base64_Two){
            WechatMore.fn.hint('您还没有上传图片');
            return;
        }
        if(_g.type < 0){
            WechatMore.fn.hint('请选择你们的恋情');
            return;
        }
        $.ajax({
            type: "POST",
            url: "Common/img.aspx",
            dataType: "json",
            data: { type: _g.type, img1: _g.base64_One, img2: _g.base64_Two },
            beforeSend: function () {
                $('#js_loading').moveIn();
            },
            success: function (msg) {
                // 返回值 msg.status
                if(msg.status == 1){ // 图片成功
                    complete(msg.img1,msg.img2,msg.similarity);
                    return;
                }else{
                    WechatMore.fn.hint(msg.msg);
                }
            },
            complete: function () {
                $('#js_loading').moveOut();
            }
        });
}
