
var WechatMore = WechatMore || {};

WechatMore.bgMp3 = function () {
    //背景音乐
    var btn = $('#js_musicBtn'),
    	oMedia = $('#bgMusic')[0];
    btn.on(WechatMore.events.start, function (e) {
        if (oMedia.paused) {
            oMedia.play();
        } else {
            oMedia.pause();
        }
        e.preventDefault();
    });
    oMedia.load();
    oMedia.play();
    if (oMedia.paused) {
        $('#wrapper').one(WechatMore.events.start, function (e) {
            oMedia.play();
            e.preventDefault();
        });
    };
    $(oMedia).on('play', function () {
        btn.addClass('musicPlay');
    });
    $(oMedia).on('pause', function () {
        btn.removeClass('musicPlay');
    });
}



$(document).ready(function(){
  var i = 0;
  if( WechatMore.step >0 )
  {
    i = $("[data-step='"+WechatMore.step+"']").prevAll().length;
  }
  swiper = new Swiper('.swiper-container', {
      direction: 'vertical',
      initialSlide : i,
      speed:800,
      followFinger : false,
      touchRatio : 0.1,
      resistanceRatio : 0,
      onSlideChangeEnd: function(swiper){
        console.log('onSlideChangeEnd:'+swiper.activeIndex );
        WechatMore.step = parseInt( swiper.slides.eq(swiper.activeIndex).data('step')); //切换结束时，告诉我现在是第几个slide

        if( WechatMore.step == 6) // 积攒页面
        {
          //如果openid对应的客户存在
          if( WechatMore.game_player_by_openid>0 )
          {
            $('#j-apply-btn').hide();
          }else{
            //显示我也要参加活动
            $('#j-apply-btn').show();
          }
        }
        if( WechatMore.step == 5)  //气球页面
        {
          $('.qiqiu-wrap').addClass('up');
        }else{
          $('.qiqiu-wrap').removeClass('up');
        }
        //根据当前页面，重新生成分享链接
        fixShareLink();
      }
  });
  WechatMore.swiper = swiper;
  $('.next-slide-btn').on( WechatMore.events.start, function(e){
    e.stopPropagation();
    swiper.slideNext();
  });
  //选择店铺
  $('.select-store-btn').on( WechatMore.events.start, function(){
    $(this).parent('.store').addClass('selected').siblings().removeClass('selected');
    var store_id = $(this).data('id');
    $('#game_player_store_id').val(store_id );
    swiper.slideNext();
  });
  //注册
  $('#j-submit-player-btn').on( WechatMore.events.start, function(){
    if (! $("#j-game-player-form").valid()) {
      return;
    }

    $.ajax( { url:  WechatMore.routes.game_players_path , type:'POST', dataType: 'json',
      data: $("#j-game-player-form").serialize(),
      success: function(data){
        //设置投票对象ID
        WechatMore.game_player_id = data.game_player.id;
        WechatMore.game_player_by_openid = WechatMore.game_player_id;
        //我要报名改为已注册
        $('#j-startup-btn').html('已报名');
        //隐藏提交按钮
        $('#j-submit-player-btn').hide();
        //升起气球
        //var qiqiu = $('#j_qiqiu').addClass('qiqiu0');
        $('.qiqiu-wrap').addClass('up');
        $('#j_qiqiu .realname').html(data.game_player.realname);

        var t=setTimeout("handleQiqiu();",5000)
        swiper.slideNext();
        //新注册用户隐藏积攒信息
        $('#j-game-player').hide();
        fixShareLink();
      }
    });


  });
  //解锁，积攒
  $('#j-unlock-btn').on( WechatMore.events.start, function(){
    //在积攒页面
    //点赞对象为分享链接的玩家，如果不是分享链接，则是为自己点赞，
    $('#vote_game_player_id').val(WechatMore.game_player_id );

    $.ajax( { url:  WechatMore.routes.votes_path , type:'POST', dataType: 'json',
      data: $("#j-vote-form").serialize(),
      success: function(data){
        //显示当前积攒数, "某某某已经解锁了120个"
        $('#j-game-player .votes_count').html( data.vote.game_player.realname+'已经解锁了'+data.vote.game_player.votes_count+'个');
        if( WechatMore.game_player_by_openid ==0 )
        {
          //显示我也要参加活动
          $('#j-apply-btn').show();
        }
        $('#j-game-player').show();
        WechatMore.game_player_votes_count = data.vote.game_player.votes_count;
        showPlayerForSharePage(  );
      }
    });
  });

  // 上传图片
  $('#file_left').on('change',function(){
      WechatMore.fn.previewImage(this,0);
  });
  $('#file_right').on('change',function(){
      WechatMore.fn.previewImage(this,1);
  });

  //生成图片
  $('#j-make-photo-btn').on( WechatMore.events.start, function(){
    if (! $("#j-wedding-photo-form").valid()) {
        return;
    }

    drawWeddingPhoto();
    swiper.slideNext();

  });

  $(".dpicker").dpicker({
    title: "请选择您的出生日期",
    cols: [
      {
        textAlign: 'center',
        values: (function () {
            var arr = [];
            for (var i=1950; i<=2010; i++) arr.push(i.toString());
            return arr;
          })()
        //如果你希望显示文案和实际值不同，可以在这里加一个displayValues: [.....]
      },
      {
        textAlign: 'center',
        values:(function () {
            var minutes = [];
            for (var i=1; i<=12; i++) minutes.push(i.toString());
            return minutes;
          })()
      },
      {
        textAlign: 'center',
        values: (function () {
            var minutes = [];
            for (var i=1; i<=31; i++) minutes.push(i.toString());
            return minutes;
          })()
      }
    ]
  });

  //绑定滑屏事件
  var time = new Date();
  touch.on('.swiper-container', 'swipeup swipedown', function(ev){
    console.log("you have done", ev.type);
    var now = new Date();
    if( now - time >500 ) // 忽略连续滑屏事件 300
    {
      if( ev.type=='swipeup')
      {
        if( !WechatMore.swiper.isEnd)
        {
          //如果是 2，3，4注册页面，只能点击按钮翻页，无法滑动
          if( WechatMore.step == 2 || WechatMore.step == 3|| WechatMore.step == 4  )
          {
            if( WechatMore.game_player_by_openid >0 )
            {
              WechatMore.swiper.slideNext();
            }else {
              if( WechatMore.step == 3)//当进入step4,再返回时，应允许向下滑动
              {
                if( parseInt( $('#game_player_store_id').val()) > 0)
                {
                  WechatMore.swiper.slideNext();
                }
              }
            }

          }else if( WechatMore.step == 10)//生成结婚证页面
          {
            var wedding_image = $("#j-wedding-image");
            if( wedding_image.attr('src') && wedding_image.attr('src').length>0 )
            {//如果用户已经生成过结婚照，允许翻页
              WechatMore.swiper.slideNext();
            }
          }else{
              WechatMore.swiper.slideNext();
          }
        }
        if( WechatMore.step == 8)
        {
        	oMedia = $('#bgMusic')[0];
          if( oMedia)
          {
            oMedia.pause();
          }
        }
      }else{
        if( !WechatMore.swiper.isBeginning)
        {
          //如果注册以后，向上滑动，跳过注册页面
          if( WechatMore.game_player_by_openid >0 )
          {
            WechatMore.swiper.slidePrev();
          }else
          { //没有注册
            if( WechatMore.step == 6 )//积攒页面
            {

            }else {
              WechatMore.swiper.slidePrev();
            }
          }
        }
      }
    }
    time = now;
  });

  //点击小车
  $('#j-car-btn').on(  WechatMore.events.start, function(e){
    $('#j-car-tips').fadeIn();
    e.preventDefault();
  });
  $('#j-car-tips').on(  WechatMore.events.start, function(e){
    $('#j-car-tips').fadeOut();
  });
  // 当用户分享页面给他人时，
  // 显示分享用户对应信息，如年龄对应的商品系列
  showPlayerForSharePage(  );
  // 根据用户积攒数显示解锁进度条

});



function handleQiqiu()
{
  //用户可能已经滑屏到其他页面了
  if( WechatMore.step == 4)
  {
    WechatMore.swiper.slideNext();
  }
}

function drawWeddingPhoto(){

    var images= { image1: $("#j-photo-1")[0], image2: $("#j-photo-2")[0], bg: $("#j-wedding-bg")[0] };
    var c= document.createElement('canvas'),//document.getElementById('j-wedding-canvas');
        ctx=c.getContext('2d');
    //结婚照图片 700*495
    var photo_image_size = [1440,988];
    var male_image_size = [105,140];
    var male_image_positon=[1140,435];
    var male_name_position=[845,485];
    var male_gender_position=[1025, 485];
    var male_birth_position=[905,545];
    var photo_ratio = photo_image_size[1]/photo_image_size[0];
    var female_image_positon=[1140,610];
    var female_name_position=[845,660];
    var female_gender_position=[1025, 660];
    var female_birth_position=[905,720];
    var release_at_position=[470,400];
    var width = photo_image_size[0]; //$('#j-image-wrap').width();
    var height = width* photo_ratio;
    var scale = width/photo_image_size[0];
    c.width=width;    c.height=height;
    //ctx.rect(0,0,c.width,c.height);
    ctx.fillStyle='black';//画布填充颜色
    ctx.font="34px/40px '微软雅黑'";
    //ctx.fill();
    ctx.drawImage(images.bg,0,0,width,height);
    ctx.drawImage(images.image1,scale*male_image_positon[0],scale*male_image_positon[1],scale*male_image_size[0],scale*male_image_size[1]);
    ctx.drawImage(images.image2,scale*female_image_positon[0],scale*female_image_positon[1],scale*male_image_size[0],scale*male_image_size[1]);
    //画名字，出生日期，性别， 发证日期
    ctx.fillText($('#male_realname').val(), scale*male_name_position[0], scale*male_name_position[1]);
    ctx.fillText($('#female_realname').val(), scale*female_name_position[0], scale*female_name_position[1]);
    ctx.fillText("男", scale*male_gender_position[0], scale*male_gender_position[1]);
    ctx.fillText("女", scale*female_gender_position[0], scale*female_gender_position[1]);

    ctx.fillText($('#male_birth').val(), scale*male_birth_position[0], scale*male_birth_position[1]);
    ctx.fillText($('#female_birth').val(), scale*female_birth_position[0], scale*female_birth_position[1]);
    var today = new Date();
    var stoday = today.toLocaleDateString(); //today.getFullYear()+'年' + today.get + today.getDate()
    //ctx.fillText(stoday, scale*release_at_position[0], scale*release_at_position[1]);

    var imageData =  c.toDataURL('image/png');
    $('#base64_image').val( imageData);
    $('#j-wedding-image').attr( 'src', imageData);

    //如果是结婚照页面，需要先上传图片，以便获取结婚照图片路径
    //$.ajax( { url:  WechatMore.routes.photographs_path , type:'POST', dataType: 'json',
    //  data: $("#j-photograph-form").serialize(),
    //  success: function(data){
    //    //console.log(data);
    //    WechatMore.shareData.weddingPageUrl = WechatMore.routes.shared_game_round_url+ '?photo_id='+ data.photograph.id+'&step='+WechatMore.step;
    //    //WechatMore.shareData.weddingImgUrl = data.photograph.image_url;
    //  }
    //});
    //创建用户，分享后可以查看
    $.ajax( { url:  WechatMore.routes.game_players_path , type:'POST', dataType: 'json',
      data: $("#j-wedding-photo-form").serialize(),
      success: function(data){
        //设置投票对象ID
        console.log(data);
        WechatMore.game_player_id = data.game_player.id;
        WechatMore.game_player_by_openid = WechatMore.game_player_id;
        WechatMore.game_player_age = data.game_player.age;
        //根据年龄显示推荐商品
        fixShareLink();
        showPlayerForSharePage( );
      }
    });
}

function showPlayerForSharePage(  )
{
  //根据年龄显示相应推荐商品
  var age =  WechatMore.game_player_age;
  var selected = '1';
  if(  age<=25 ){
    selected = '1';
  }else if (  age>25 && age<=30 ){
    selected = '2';
  }else if (  age>30 && age<=35 ){
    selected = '3';
  }else{
    selected = '4';
  }
  $('.image-style').removeClass('selected');
  $('.image-style.style'+selected).addClass('selected');
  //根据积攒数显示解锁进度条
  var votes_count =  WechatMore.game_player_votes_count;

  if( votes_count >0 )
  {
    $('.j-prize').each(function(){
      var $this = $(this);
      var score = $this.data('score');
      var percent = votes_count/parseInt(score);
      if(percent>=1){
        $this.addClass('unlock');
        percent =1;
      }
      $this.find('.progress').css('width', percent*100+'%');
    });
  }
}
