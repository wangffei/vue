var $ = layui.$ ;

//切换语言方法
function language(obj){
	window.location = "./screen?id="+global.id+"&language="+obj.value ;
}

//layui的文件上传模块
layui.use('upload', function(){
  var upload = layui.upload;
  
  var id = "" ;
  
  var uploadInst = upload.render({
    elem: '#video'
    ,url: 'upload'
    ,done: function(res){
      layer.close(id) ;
      if(res.code == 200){
    	  vue.$data.name = res.msg ;
    	  if(vue.$data.TVscreenInfo.panel.MAIN.item == undefined){
    		  vue.$data.TVscreenInfo.panel.MAIN.item = 0 ;
    	  }
    	  //vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.info[vue.$data.editeEl["content_item"]]["video"] = res.data ;
    	  Vue.set(vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.info[vue.$data.editeEl["content_item"]], "video", res.data)
      }
    }
    ,error: function(){
      layer.close(id) ;
      layer.alert("视频上传失败") ;
    },
    before:function(e){
    	console.log(e)
    	id = layer.load(1) ;
    } ,
    accept:"video"
  });
});

$(function(){
	//是否添加页面刷新事件
	var flush = false ;
	//监听页面上信息是否发生变化，如果改变了就添加页面刷新提示事件（主要怕用户数据没有保存直接刷新或者关闭页面了）
	vue.$watch('TVscreenInfo', function(n  , o){
		if(vue.$data.isChange == undefined){
			vue.$data.isChange = false ;
		}else{
			vue.$data.isChange = true ;
			if(!flush){
				//监听页面刷新，用于提示用户数据未保存
				window.onbeforeunload = function(e) {
			    	 var dialogText = '数据未保存';
				     e.returnValue = dialogText;
				     return dialogText;
				};
				flush = true ;
			}
		}
	}, {
	    deep: true
	});
})

//使用右键菜单插件
layui.config({base: './js/mouseRightMenu/'})
layui.use(['mouseRightMenu','layer','jquery'],function(){
	global.mouseRightMenu = layui.mouseRightMenu,global.layer = layui.layer;
		
})