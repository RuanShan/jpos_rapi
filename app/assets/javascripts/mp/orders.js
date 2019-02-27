// 我的最近订单
//$(document).on('click', '.recent-orders .weui-navbar__item', function () {
//  $(this).addClass('weui-bar__item_on').siblings('.weui-bar__item_on').removeClass('weui-bar__item_on');
//});

$(document).on('click', '.recent-order-states .recent-order-state', function () {
  // 最近订单弹出层初始化
  //var pageii = layer.open({
  //  type: 1
  //  ,content: $('.recent-orders-layer')
  //  ,anim: 'scale'
  //  ,style: 'position:fixed; left:0; top:0; width:100%; height:100%; border: none; -webkit-animation-duration: .5s; animation-duration: .5s;'
  //});
});

$(document).on(" turbolinks:load", function() {
  var states = ['pending', 'working', 'ready'];
  var initial = 0;
  for(var i = 0; i< states.length; i++ ){
    if( states[i] == Jpos.select_group_state){
      initial = i; break;
    }
  }
  weui.tab('#recent-orders-tab',{
      defaultIndex: initial,
      onChange: function(index){
          console.log(index);
     }
  });
  // init Infinite Scroll
  if( $('.pagination__next').length>0 ){
    $('.my-orders .orders').infiniteScroll({
      path: '.pagination__next',
      append: '.order',
      status: '.scroller-status',
      hideNav: '.pagination',
    });    
  }

})
