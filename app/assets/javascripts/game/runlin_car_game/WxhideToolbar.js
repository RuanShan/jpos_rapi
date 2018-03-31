


//分享和关注
document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
	
	WeixinJSBridge.call('hideToolbar');
    // 设置字段大小的回调,目前有1-4个大小等级
   /* WeixinJSBridge.on('menu:setfont',function(argv){
        // 示例代码
        var num = parseInt(argv.fontSize);
        changefont(num);
	//alert(num);
        return;

    });
    WeixinJSBridge.on('menu:share:appmessage', function(argv){
        sendShareCommand('sendAppMessage');
	//alert('sendAppMessage');
        return;
    });
    WeixinJSBridge.on('menu:share:timeline', function(argv){
        sendShareCommand('shareTimeline');
	//alert('shareTimeline');
        return;
    });
    function sendShareCommand(command) {
       
        WeixinJSBridge.invoke(command,{
            "appid" : 'wx74983c7df9298f2e',
            "img_url": "http://ft.moad.cn/moad/infinitiwx/images/1.png", // 分享到朋友圈的缩略图
            "img_width": "200",// 图片的长度
            "img_height": "200", // 图片高度
            "link": window.location.href,// 连接地址
            "desc": "英菲尼迪万人盛典抢票开启，水果姐中国首秀", // 描述
            "title": "英菲尼迪万人盛典抢票开启，水果姐中国首秀" // 分享标题
        },function(res){
            // 返回res.err_msg,取值
            // share_timeline:fail　发送失败
            // share_timeline:ok 发送成功
            // share_timeline:cancel 用户取消朋友圈分享
            // share_timeline:confirm 分享朋友圈成功
            // send_app_msg:cancel  用户取消分享朋友成功
            // send_app_msg:confirm 分享朋友成功
        });
    }
    // 分享到朋友圈
    window.bindEvent('#shareTimeline', 'click', function(){
        sendShareCommand(this);
	//alert('#shareTimeline');
    });
    window.bindEvent('#sendAppMessage', 'click', function(){
        sendShareCommand(this);
	//alert('#sendAppMessage');
    });

    window.bindEvent('#isShareBuy', 'click', function(){
        sendShareCommand(this);
	//alert('#isShareBuy');
    });*/

}, false);
