
	var body, blockSize, GameLayer = [], GameLayerBG, touchArea = [], GameTimeLayer;
	var transform, transitionDuration;

	function init (argument) {
		showWelcomeLayer();
		body = document.getElementById('gameBody') || document.body;
		body.style.height = window.innerHeight+'px';
		transform = typeof(body.style.webkitTransform) != 'undefined' ? 'webkitTransform' : (typeof(body.style.msTransform) != 'undefined'?'msTransform':'transform');
		transitionDuration = transform.replace(/ransform/g, 'ransitionDuration');

		GameTimeLayer = document.getElementById('GameTimeLayer');
		GameLayer.push( document.getElementById('GameLayer1') );
		GameLayer[0].children = GameLayer[0].querySelectorAll('div');
		GameLayer.push( document.getElementById( 'GameLayer2' ) );
		GameLayer[1].children = GameLayer[1].querySelectorAll('div');
		GameLayerBG = document.getElementById( 'GameLayerBG' );
		if( GameLayerBG.ontouchstart === null ){
			GameLayerBG.ontouchstart = gameTapEvent;
		}else{
			GameLayerBG.onmousedown = gameTapEvent;
			document.getElementById('landscape-text').innerHTML = '点我开始玩耍';
			document.getElementById('landscape').onclick = winOpen;
		}
		gameInit();
		window.addEventListener('resize', refreshSize, false);

		setTimeout(function(){
			var btn = document.getElementById('ready-btn');
			btn.className = 'btn';
			btn.innerHTML = ' 预备，上！'
			btn.style.backgroundColor = '#F60';
			btn.onclick = function(){
				closeWelcomeLayer();
			}

		}, 500);
	}
	function winOpen() {
		window.open(location.href+'?r='+Math.random(), 'nWin', 'height=500,width=320,toolbar=no,menubar=no,scrollbars=no');
		var opened=window.open('about:blank','_self'); opened.opener=null; opened.close();
	}
	var refreshSizeTime;
	function refreshSize(){
		clearTimeout(refreshSizeTime);
		refreshSizeTime = setTimeout(_refreshSize, 200);
	}
	function _refreshSize(){
		countBlockSize();
		for( var i=0; i<GameLayer.length; i++ ){
			var box = GameLayer[i];
			for( var j=0; j<box.children.length; j++){
				var r = box.children[j],
					rstyle = r.style;
				rstyle.left = (j%4)*blockSize+'px';
				rstyle.bottom = Math.floor(j/4)*blockSize+'px';
				rstyle.width = blockSize+'px';
				rstyle.height = blockSize+'px';
			}
		}
		var f, a;
		if( GameLayer[0].y > GameLayer[1].y ){
			f = GameLayer[0];
			a = GameLayer[1];
		}else{
			f = GameLayer[1];
			a = GameLayer[0];
		}
		var y = ((_gameBBListIndex)%10)*blockSize;
		f.y = y;
		f.style[transform] = 'translate3D(0,'+f.y+'px,0)';

		a.y = -blockSize*Math.floor(f.children.length/4)+y;
		a.style[transform] = 'translate3D(0,'+a.y+'px,0)';

	}
	function countBlockSize(){
		blockSize = body.offsetWidth/4;
		body.style.height = window.innerHeight+'px';
		GameLayerBG.style.height = window.innerHeight+'px';
		touchArea[0] = window.innerHeight-blockSize*0;
		touchArea[1] = window.innerHeight-blockSize*3;
	}
	var _gameBBList = [], _gameBBListIndex = 0, _gameOver = false, _gameStart = false, _gameTime, _gameTimeNum, _gameScore;
	function gameInit(){
        createjs.Sound.registerSound( {src: WechatMore.assets.audio_err_path, id:"err"} );
        createjs.Sound.registerSound( {src: WechatMore.assets.audio_end_path, id:"end"} );
        createjs.Sound.registerSound( {src: WechatMore.assets.audio_tap_path, id:"tap"} );
		gameRestart();
	}
	function gameRestart(){
		console.log('gameRestart');
		_gameBBList = [];
		_gameBBListIndex = 0;
		_gameScore = 0;
		_gameOver = false;
		_gameStart = false;
		_gameTimeNum = 1500;
		GameTimeLayer.innerHTML = creatTimeText(_gameTimeNum);
		countBlockSize();
		refreshGameLayer(GameLayer[0]);
		refreshGameLayer(GameLayer[1], 1);
	}
	function gameStart(){
		_gameStart = true;
		_gameTime = setInterval(gameTime,15);
	}
	function gameOver(){
		_gameOver = true;
		clearInterval(_gameTime);
		$.ajax({
			url: WechatMore.routes.score_game_player_path, type:'put', data: { game_player_id: WechatMore.game_player_id, 'game_player[score]': _gameScore },
			success: function( data ){
				GameLayerBG.className = '';
				console.log( data );
				showGameScoreLayer( data.game_player );
			},
			error: function(){
        alert('sorry, can not connect to server!');
			}
		});

		//setTimeout(function(){
		//	GameLayerBG.className = '';
		//	showGameScoreLayer();
		//}, 1500);
	}
	function gameTime(){
		_gameTimeNum --;
		if( _gameTimeNum <= 0){
			GameTimeLayer.innerHTML = '&nbsp;&nbsp;&nbsp;&nbsp;时间到！';
			gameOver();
			GameLayerBG.className += ' flash';
			createjs.Sound.play("end");
		}else{
			GameTimeLayer.innerHTML = creatTimeText(_gameTimeNum);
		}
	}
	function creatTimeText( n ){
		var text = (100000+n+'').substr(-4,4);
		text = '&nbsp;&nbsp;'+text.substr(0,2)+"'"+text.substr(2)+"''"
		return text;
	}
	var _ttreg = / t{1,2}(\d+)/, _clearttClsReg = / t{1,2}\d+| bad/;
	function refreshGameLayer( box, loop, offset ){
		var i = Math.floor(Math.random()*1000)%4+(loop?0:4);
		for( var j=0; j<box.children.length; j++){
			var r = box.children[j],
				rstyle = r.style;
			rstyle.left = (j%4)*blockSize+'px';
			rstyle.bottom = Math.floor(j/4)*blockSize+'px';
			rstyle.width = blockSize+'px';
			rstyle.height = blockSize+'px';
			r.className = r.className.replace(_clearttClsReg, '');
			if( i == j ){
				_gameBBList.push( {cell:i%4, id:r.id} );
				r.className += ' t'+(Math.floor(Math.random()*1000)%21+1);
				r.notEmpty = true;
				i = ( Math.floor(j/4)+1)*4+Math.floor(Math.random()*1000 )%4;
			}else{
				r.notEmpty = false;
			}
		}
		if( loop ){
			box.style.webkitTransitionDuration = '0ms';
			box.style.display          = 'none';
			box.y                      = -blockSize*(Math.floor(box.children.length/4)+(offset||0))*loop;
			setTimeout(function(){
				box.style[transform] = 'translate3D(0,'+box.y+'px,0)';
				setTimeout( function(){
					box.style.display     = 'block';
				}, 100 );
			}, 200 );
		} else {
			box.y = 0;
			box.style[transform] = 'translate3D(0,'+box.y+'px,0)';
		}
		box.style[transitionDuration] = '150ms';
	}
	function gameLayerMoveNextRow(){
		for(var i=0; i<GameLayer.length; i++){
			var g = GameLayer[i];
			g.y += blockSize;
			if( g.y > blockSize*(Math.floor(g.children.length/4)) ){
				refreshGameLayer(g, 1, -1);
			}else{
				g.style[transform] = 'translate3D(0,'+g.y+'px,0)';
			}
		}
	}
	function gameTapEvent(e){
		if (_gameOver) {
			return false;
		}
		var tar = e.target;
		var y = e.clientY || e.targetTouches[0].clientY,
			x = (e.clientX || e.targetTouches[0].clientX)-body.offsetLeft,
			p = _gameBBList[_gameBBListIndex];
		if ( y > touchArea[0] || y < touchArea[1] ) {
			return false;
		}
		if( (p.id==tar.id&&tar.notEmpty) || (p.cell==0&&x<blockSize) || (p.cell==1&&x>blockSize&&x<2*blockSize) || (p.cell==2&&x>2*blockSize&&x<3*blockSize) || (p.cell==3&&x>3*blockSize) ){
			if( !_gameStart ){
				gameStart();
			}
        	createjs.Sound.play("tap");
			tar = document.getElementById(p.id);
			tar.className = tar.className.replace(_ttreg, ' tt$1');
			_gameBBListIndex++;
			_gameScore ++;
			gameLayerMoveNextRow();
		}else if( _gameStart && !tar.notEmpty ){
			createjs.Sound.play("err");
			gameOver();
			tar.className += ' bad';
		}
		return false;
	}
	function createGameLayer(){
		var html = '<div id="GameLayerBG">';
		for(var i=1; i<=2; i++){
			var id = 'GameLayer'+i;
			html += '<div id="'+id+'" class="GameLayer">';
			for(var j=0; j<10; j++ ){
				for(var k=0; k<4; k++){
					html += '<div id="'+id+'-'+(k+j*4)+'" num="'+(k+j*4)+'" class="block'+(k?' bl':'')+'"></div>';
				}
			}
			html += '</div>';
		}
		html += '</div>';

		html += '<div id="GameTimeLayer"></div>';

		return html;
	}
	function closeWelcomeLayer(){
		var l = document.getElementById('welcome');
		l.style.display = 'none';
	}
	function showWelcomeLayer(){
		var l = document.getElementById('welcome');
		l.style.display = 'block';
	}
	function showGameScoreLayer( game_player ){
		var l = document.getElementById('GameScoreLayer');
		//var c = document.getElementById(_gameBBList[_gameBBListIndex-1].id).className.match(_ttreg)[1];
		//l.className = l.className.replace(/bgc\d/, 'bgc'+1);
		document.getElementById('GameScoreLayer-text').innerHTML = shareText(game_player);
		document.getElementById('GameScoreLayer-score').innerHTML = '得分&nbsp;&nbsp;'+game_player.score;

		document.getElementById('GameScoreLayer-bast').innerHTML = '最佳&nbsp;&nbsp;'+game_player.max_score;
		l.style.display = 'block';

    WechatMore.shareData.title = '我撕下'+_gameScore+'商品名牌，不服来挑战！！！';

    //var l = document.getElementById('adhtml').innerHTML;
    //document.getElementById('ad').innerHTML = l;
    //document.getElementById('ad1').innerHTML = l;
		for(var i=0; i<game_player.game_awards.length; i++)
		{
			var award = game_player.game_awards[i];
			if( award.type== 'CardPrize')
			{
				//卡券奖励
				wx.addCard({
						cardList: [{
								cardId: '',
								cardExt: ''
						}], // 需要添加的卡券列表
						success: function (res) {
								var cardList = res.cardList; // 添加的卡券列表信息
						}
				});
			}else if ( award.type== 'CashPrize')
			{
				//红包奖励
			}
		}
	}


	function showEnd(){
		var l = document.getElementById('GameScoreLayer-share');
		l.style.display = 'block';
		document.getElementById('share-wx').style.display = 'none';
	}


	function hideGameScoreLayer(){
		var l = document.getElementById('GameScoreLayer');
		l.style.display = 'none';
	}
	function replayBtn(){
		gameRestart();
		hideGameScoreLayer();
	}
	function backBtn(){
		gameRestart();
		hideGameScoreLayer();
		showWelcomeLayer();
	}

	function shareText( game_player ){
		var score = game_player.score;
    var num = game_player.current_position;
    var percent = game_player.percent_position;
    var txt1 = "排名第"+ num +"位，击败了"+ percent + "% 的人";
		if( score <= 69 )
			return '哈哈尊敬顾客！您撕下'+score+'商品名牌！<br/>'+txt1+ '<br/>亲，得加油哦。朋友圈中你是多少名！';
		if( score <= 269 )
			return '酷！您撕下'+score+'商品名牌！<br/>'+txt1+ '<br/>亲,你好棒哦。';
		if( score <= 319 )
			return '帅呆了！撕下'+score+'商品名牌！<br/>'+txt1+ '<br/>爱死你了，朋友圈终于清净了，再看看有谁能超越我的！';
		if( score <= 400 )
			return '太牛了！撕下'+score+'商品名牌！<br/>'+txt1+ '<br/>你是我见过最棒的，你击败了全国百分之99的精神病人，晚上不睡觉也在撕，​奥巴马和金正恩都惊呆了！';
		return '膜拜ing！撕下'+score+'商品名牌！<br/> 战胜了神经病院 99% 的人，全球排名第1 <br/>你是宇宙第一强人，再也没人能超越你了！';
	}

	function share(){
		document.getElementById('share-wx').style.display = 'block';
		document.getElementById('share-wx').onclick = function(){
			this.style.display = 'none';
		};
	}

	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {

	    WeixinJSBridge.on('menu:share:appmessage', function(argv) {
	        WeixinJSBridge.invoke('sendAppMessage', {
	            "img_url": WechatMore.shareData.img_url,
	            "link": WechatMore.shareData.link,
	            "desc": WechatMore.shareData.desc,
	            "title": WechatMore.shareData.title
	        }, function(res) {
	        	showEnd();
	        })
	    });

	    WeixinJSBridge.on('menu:share:timeline', function(argv) {
	        WeixinJSBridge.invoke('shareTimeline', {
	            "img_url": WechatMore.shareData.img_url,
	            "img_width": "640",
	            "img_height": "640",
							"link": WechatMore.shareData.link,
	            "desc": WechatMore.shareData.desc,
	            "title": WechatMore.shareData.title
	        }, function(res) {
          showEnd();
	        });
	    });
	}, false);

//开始游戏
document.write(createGameLayer());
init();
