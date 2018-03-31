//= require common_wechat
//= require jquery.cookie
//= require createjs-2013.12.12.min
//= require game/counting/main.js
//= require game/counting/qipa_app.js
//= require game/counting/qipa_stage.js

var _cfg = {
	startFunc: qp_v,
	img: {
		path: "/assets/game/counting/",
		manifest: [{
			src: "m0.png",
			id: "m0"
		},
		{
			src: "mb0.png",
			id: "mb0"
		},
		{
			src: "d0.png",
			id: "d0"
		},
		{
			src: "starttip.png",
			id: "starttip"
		},
		{
			src: "tmbg.png",
			id: "tmbg"
		},
		{
			src: "splashtitle.png",
			id: "splashtitle"
		},
		{
			src: "tmicon.png",
			id: "tmicon"
		},
		{
			src: "start.png",
			id: "start"
		},
		{
			src: "rank.png",
			id: "rank"
		},
		{
			src: "share.png",
			id: "share"
		},
		{
			src: "dlgbg.png",
			id: "dlgbg"
		}]
	},
	audio: {
		path: "/audios/game/counting/",
		manifest: [{
			src: "count.mp3",
			id: "count"
		}]
	}
};
qipaStage.init(_cfg);
