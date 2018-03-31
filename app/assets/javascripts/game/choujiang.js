// 1、结束签到后，粉丝无法进入。
// 2、一次抽奖，只抽一个名额。从小奖开始抽取。
// 3、一个人不能兼中。
//
var choujiang = {
  playerIndex: 0,  //
  players: [],     //可抽獎人員, 没有得过奖的
  //var awardedPlayers =[];
  // 签到人员统计
  playerCount: 0,
  prizeCount: 0 // 一次抽取多少个奖
}
choujiang.init = function(){
  $('.b_player_count').html( choujiang.playerCount);


  choujiang.channel = App.choujiang_game_channel = App.cable.subscriptions.create(
    {
      channel:"GameRoundChannel",
      game_round_id: WechatMore.game_round_id,
      terminal: WechatMore.terminal,
    },
    {
      connected: function() {
        // Called when the subscription is ready for use on the server
        this.perform('game_state');
      },

      disconnected: function() {
        // disable for debug
        //setTimeout(function () {
        //    location.reload();
        //}, 2000);
      },

      received: function(data) {
        var now = new Date(data.now);
        var game_round = data.game_round;
        var state = choujiang.nowStatus = data.state;
        App.debug( state+'-'+ data.action  );

        if( data.action == 'game_state')
        {
          if( state == 'ready' )
          {
            choujiang.cj_ready();
          }

        }
        else if( data.action == 'restart')
        {
          location.href = WechatMore.routes.check_in_game_url;
        }
        else if( data.action == 'reset')
        {
          location.href = WechatMore.routes.check_in_game_url;
        }
        else if( data.action == 'restart_award')
        {
          location.reload();
        }
        else if( data.action == 'award_player')
        {
          choujiang.getUser(data.game_award_player, data.game_award,function(){
  					numPrizeName = {};
  				});
        }else if( data.action == 'get_awarded_players')
        {
          $.each(data.game_players,function(i, player){
            console.debug( player);
            var luck_user = '<div class="result-line had_luck_user award-'+data.game_award_id+'" style="display: block;">';
              luck_user += '<div class="result-num">'+player.game_awards[0].name+'</div>';
                luck_user += '<div class="user" style="background-image: url('+player.avatar+');">';
                luck_user += '<span class="nick-name">'+player.nickname+'</span></div></div>';
              $(".b_award_players").prepend(luck_user);
          })
        }
        else if( data.action == 'get_noaward_players')
        {
          choujiang.players = data.game_players;
          var count = choujiang.players.length;
          $(".usercount-label").html(count);
          $(".control.button-run").fadeIn();
        }
      }
    }
  )

  $(".control.button-run").on("click",
  function() {
      choujiang.start_lottory()
  });
  $(".control.button-stop").on("click",
  function() {
      choujiang.stop_lottory()
  });
  $("#award_select").change( function(){
    console.debug( "award_select changed");
  });
  $("#b_restart_award").click(function(){
    choujiang.restart();
  })
  //再来一次
  $('#b_restart_game').click(function () {
     choujiang.fire('restart');
  });

  $('#b_check_over_game').hide();
  $('#b_start_game').hide();
  $('#b_restart_game').show();

  $('#b_reset_game').click(function(){
     choujiang.fire('reset')
  })

};

choujiang.restart=function(){
  //如果中獎人員為0，無需重新開始
	if($(".b_award_players .had_luck_user").length==0){
		return;
	}

  layer.confirm('确定重新抽奖吗？', {
    btn: ['确定','取消'] //按钮
  }, function(){
    choujiang.fire('restart_award');
  }, function(){

  });
};


choujiang.getUser = function(player, game_award,f) {
    /*if (audio_GetOne) {
        audio_GetOne.play()
    }*/
    $(".b_award_players").scrollTop(0);
    var b = $(".b_award_players").scroll(0).children(".result-line").length ;
    var a = $('<div class="result-line had_luck_user">  <div class="result-num">1</div> <i class="delLottery"></i></div>');
	  a.addClass('award-'+game_award.id);
    a.find(".result-num").html( game_award.name );
    a.prependTo(".b_award_players").slideDown();
    var e = a.offset();
    var c = $(".lottery-run .user");
    var d = c.clone().appendTo("body").css({
        position: "absolute",
        top: c.offset().top,
        left: c.offset().left,
        width: c.width(),
        height: c.height()
    }).animate({
        width: 60,
        height: 60,
        top: e.top + 5,
        left: e.left + 50
    },
    500,
    function() {
        var g = d.css("background-image");
        d.appendTo(a).removeAttr("style").css({
            "background-image": g
        });
		a.find("i").attr('onclick','delLuckUser('+player.id+');');
        if ($.isFunction(f)) {
            f.call(this)
        }
    })
};

// cj 抽奖
choujiang.cj_ready = function () {
  choujiang.players = [];
  // 没有得奖人员信息
  choujiang.fire('get_noaward_players');
  // 得奖人员信息
  choujiang.fire('get_awarded_players');

}


choujiang.tip=function(msg,autoClose){
	var div = $("#poptip");
	var content =$("#poptip_content");
	if(div.length<=0){
		div = $("<div id='poptip'></div>").appendTo(document.body);
		content =$("<div id='poptip_content'>" + msg + "</div>").appendTo(document.body);
	}else{
		content.html(msg);
		content.show(); div.show();
	}
	if(autoClose) {
		setTimeout(function(){
			content.fadeOut(500);
			div.fadeOut(500);
		},1000);
	}
}

choujiang.tip_close=function(){
	$("#poptip").fadeOut(500);
	$("#poptip_content").fadeOut(500);
}


//choujiang.getLuckUser = function (game_award_id){
//  choujiang.fire("awarded_players", {"game_award_id":game_award_id})
//    $.ajax({
//		url: WechatMore.routes.build_api_v1_game_award_players_path( game_award_id ),
//  	data:{"api_key":WechatMore.api_key, "award_id":game_award_id},
//    	type:"get",
//    	dataType:'json',
//    	success:function(d){
//		    if(d.game_award_players.length>0){
//					$.each(d.game_award_players,function(i,val){
//						var list_num = i +1;
//						var luck_user = '<div class="result-line had_luck_user award-'+game_award_id+'" style="display: block;">';
//							luck_user += '<div class="result-num">'+list_num+'</div>';
//							luck_user += '<i class="delLottery" onclick="delLuckUser('+val.id+')"></i>';
//								luck_user += '<div class="user" style="background-image: url('+val.avatar+');">';
//								luck_user += '<span class="nick-name">'+val.nickname+'</span></div></div>';
//							$(".b_award_players").prepend(luck_user);
//					})
//		    }
//    	}
//    });
//}

choujiang.showLayer=function(i){
	$("#layer"+i).fadeIn();
	$("body").append("<div class=\"layerBlank\"></div>");
};
choujiang.closeLayer=function(o){
	$(o).parents(".layerStyle").hide();
	$("div").remove(".layerBlank");
};

choujiang.changeClick=function(){

}

choujiang.recoverClick=function(){

}

var isChange=true;
var num;
var timer;
var numPrizeName;


choujiang.start_lottory=function(i){

	var award_id = $("#award_select option:selected").val();
  var count = $("#award_select option:selected").data('game-award-prize-count')
  var awarded_player_count = $(".result-line.award-"+award_id).length;

	if(award_id==-1){
		choujiang.alert('请选择奖项');
		return;
	}
 var tagNum = $("#tag_num").val()==""?0:$("#tag_num").val();

		if( awarded_player_count==count){
			$("#award_select").removeAttr("disabled");
		  $(".control.button-run").html("开始抽奖");
			clearInterval(timer);
			choujiang.prizeCount = 0;
			isChange = true;
		  choujiang.recoverClick();
			choujiang.alert('亲，当前奖项已经抽满人数，不能再进行抽奖！');
			return;
		}
		if(choujiang.players.length ==0){
			$("#award_select").removeAttr("disabled");
		   $(".control.button-run").html("开始抽奖");
			clearInterval(timer);
			choujiang.prizeCount = 0;
			isChange = true;
		  choujiang.recoverClick();

			choujiang.alert('参与抽奖人数太少没法抽了！！');
			return;

		}

	if(i!=2){

		choujiang.prizeCount=1;
		var base = $(".usercount-label").html();

		if(parseInt(base)==0){
			choujiang.alert('可抽奖人数为0！不能再进行抽奖');
			return ;
		}
		$("#award_select").attr("disabled","disabled");
	}
	timer=setInterval(function(){
		choujiang.SelectRandomUser();
	},50)
	$(".control.button-run").fadeOut()
	$(".control.button-stop").fadeIn()
}


choujiang.stop_lottory=function(){
  var award_id = $("#award_select option:selected").val();
  var count = $("#award_select option:selected").data('game-award-prize-count')
  var awarded_player_count = $(".result-line").length-1;
	//for(var i=0;i<choujiang.players.length;i++){
	//	    if(choujiang.players[i].nd_id == award_id){
	//				numPrizeName = choujiang.players[i];
	//				choujiang.players_index = i;
	//				$(".lottery-run .user").css({
	//					"background-image": "url(" + numPrizeName.avatar + ")"
	//				});
	//				$(".lottery-run .user .nick-name").html(numPrizeName.nickname);
	//				break;
	//		}
	//}

	if(numPrizeName.nd_id!=award_id && numPrizeName.nd_id > 0){
			for(var i=0;i<choujiang.players.length;i++){
				if(choujiang.players[i].nd_id == 0){
						numPrizeName = choujiang.players[i];
						choujiang.playerIndex = i;
						$(".lottery-run .user").css({
							"background-image": "url(" + numPrizeName.avatar + ")"
						});
						$(".lottery-run .user .nick-name").html(numPrizeName.nickname);
						break;
				}
			}
	}
	$(".control.button-run").fadeIn()
	$(".control.button-stop").fadeOut()
	clearInterval(timer);//清除定时器 不在滚动
	var base = $(".usercount-label").html();

	//if(num>0 && base!="0"){
    	choujiang.checked();
	//}else{
	//	return ;
	//}
	choujiang.prizeCount--;
	if(choujiang.prizeCount>0){
    	$(".control.button-run").html("开始抽奖("+choujiang.prizeCount+")");
	}else{
		$("#award_select").removeAttr("disabled");
		$(".control.button-run").html("开始抽奖");
	}
	if(choujiang.prizeCount>0){//如果选择的人数没抽完
		if(isChange){
			choujiang.changeClick();
			isChange = false;
		}

		setTimeout(function(){
			choujiang.start_lottory(2);
		},1000);
		setTimeout(function(){
			choujiang.stop_lottory();
		},2000);
	}else{
		isChange = true;
		choujiang.recoverClick();
	}
}

//选择中奖人员
choujiang.checked=function(){
		//var msg = new Array();
		//msg = numPrizeName[0].split("|");
    var player =  choujiang.players[choujiang.playerIndex];
    var award_id = $("#award_select option:selected").val();
    choujiang.fire( "award_player", {
      "game_player_id": player.id,
      "game_award_id":award_id } );

		choujiang.players.splice(choujiang.playerIndex,1);

		$(".usercount-label").html(choujiang.players.length);
		if(choujiang.players.length==0){
			choujiang.alert('全部人数已经抽奖完毕！');
			return ;
		}
}

choujiang.SelectRandomUser=function(){
	var count = choujiang.players.length - 1;
	var random_index = Math.round(Math.random() * count);
    numPrizeName = choujiang.players[random_index];
	choujiang.playerIndex = random_index;
	$(".lottery-run .user").css({
      "background-image": "url(" + numPrizeName.avatar + ")"
    });
  $(".lottery-run .user .nick-name").html(numPrizeName.nickname);
}

/**
 * 发送
 * @param url
 * @param params
 */
choujiang.fire = function(url, params)
{
    choujiang.channel.perform(url, params);
}

choujiang.alert = function(msg)
{
  layer.alert(msg, {icon: 6});
}
