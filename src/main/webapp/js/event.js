var fileName = "" ;
var fileSize = "" ;
//文件操作事件
function selectFile(e){
	event = event ? event : window.event; 
	if(event.target.files[0] == undefined){
		return ;
	}
	var r = new FileReader();
	var id = layer.load(1); //风格1的加载
	r.readAsDataURL(event.target.files[0]);		
	var base64 = "";
	var size = event.target.files[0].size ;
	var currentSize = 0 ;
	if(!event.target.files[0].type.startsWith("image")){
		layer.alert("此处只能选择图片") ;
		layer.close(id) ;
		return
	}
	r.onload = function(e) {
		base64 = e.target.result;
		currentSize += (e.target.result.substr(e.target.result.indexOf(",") + 1)).length*0.75 ;
		if(currentSize >= size){
			vue.$data.fun(base64) ;
			layer.close(id) ;
		}
	}
}


//右键删除组件
function deleteComponent(position , id , type){
	
	var data = {content:$(this).html()}
		var menu_data=[
		{'data':data,'type':1,'title':'删除'}
	]
	var self = this ;
	global.mouseRightMenu.open(menu_data,false,function(d){
		if(type == "CONTENT"){
			console.log(vue.$data.TVscreenInfo.panel.MAIN.item)
			if(vue.$data.TVscreenInfo.panel.MAIN.item != undefined || typeof(vue.$data.TVscreenInfo.panel.MAIN.item) != "undefined"){
				var id_1 = "" ;
				var typeid = "" ;
				var content = "" ;
				var control = "" ;
				try{
					id_1 = vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.id ;
					typeid = vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.typeid ;
					content = vue.$data.TVscreenInfo.panel.MAIN.content ;
					control = vue.$data.TVscreenInfo.showControl[position][id] ;
				}catch(err){
					
					layer.open({
					  title: '错误'
					  ,content: '删除失败'
					});     
					return ;
				}
				
				try{
					vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.id = undefined ;
					vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.typeid = "" ;
					vue.$data.TVscreenInfo.panel.MAIN.content = false ;
					vue.$data.TVscreenInfo.showControl[position][id] = false ;
					vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.info.splice(0 , vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.info.length) ;
				}catch(err){
					vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.id = id_1 ;
					vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item].data.typeid = typeid ;
					vue.$data.TVscreenInfo.panel.MAIN.content = content ;
					vue.$data.TVscreenInfo.showControl[position][id] = control ;
					
					layer.open({
					  title: '错误'
					  ,content: '删除失败'
					});     
					return ;
				}
			}else{
				if(vue.$data.TVscreenInfo.panel.MAIN.data.length == 1){
					var id_1 = "" ;
					var typeid = "" ;
					var content = "" ;
					var control = "" ;
					try{
						id_1 = vue.$data.TVscreenInfo.panel.MAIN.data[0].data.id ;
						typeid = vue.$data.TVscreenInfo.panel.MAIN.data[0].data.typeid ;
						content =vue.$data.TVscreenInfo.panel.MAIN.content ;
						control = vue.$data.TVscreenInfo.showControl[position][id] ;
					}catch(err){
						layer.open({
						  title: '错误'
						  ,content: '删除失败'
						});     
						return ;
					}
					
					try{
						vue.$data.TVscreenInfo.panel.MAIN.data[0].data.id = undefined ;
						vue.$data.TVscreenInfo.panel.MAIN.data[0].data.typeid = "" ;
						vue.$data.TVscreenInfo.panel.MAIN.content = false ;
						vue.$data.TVscreenInfo.showControl[position][id] = false ;
						vue.$data.TVscreenInfo.panel.MAIN.data.splice(0 , 1) ;
					}catch(err){
						vue.$data.TVscreenInfo.panel.MAIN.data[0].data.id = id_1 ;
						vue.$data.TVscreenInfo.panel.MAIN.data[0].data.typeid = typeid ;
						vue.$data.TVscreenInfo.panel.MAIN.content = content ;
						vue.$data.TVscreenInfo.showControl[position][id] = control ;
						
						layer.open({
						  title: '错误'
						  ,content: '删除失败'
						});     
						return ;
					}
				}
			}
		}else if(type == "BAR"){
			var sid = layer.confirm('此操作会删除整个导航栏和内容组件的数据，是否继续', {
				  btn: ['确认', '取消'] //可以无限个按钮
				}, function(index){		
					var bar = "" ;
					var content = "" ;
					var item = "" ;
					var id_1 = "" ;
					var control = "" ;
					try{
						var bar = vue.$data.TVscreenInfo.panel.MAIN.bar ;
						var content = vue.$data.TVscreenInfo.panel.MAIN.conten ;
						var item = vue.$data.TVscreenInfo.panel.MAIN.item ;
						var id_1 = vue.$data.TVscreenInfo.panel.MAIN.id ;
						var control = vue.$data.TVscreenInfo.showControl[position][id] ;
					}catch(err){
						layer.open({
						  title: '错误'
						  ,content: '删除失败'
						});     
						return ;
					}
					try{
						vue.$data.TVscreenInfo.panel.MAIN.bar = false ;
	 					vue.$data.TVscreenInfo.panel.MAIN.content = false ;
	 					vue.$data.TVscreenInfo.panel.MAIN.item = undefined ;
	 					vue.$data.TVscreenInfo.panel.MAIN.id = undefined ;
	 					vue.$data.TVscreenInfo.showControl[position][id] = false ;
	 					vue.$data.TVscreenInfo.panel.MAIN.data.splice(0 , vue.$data.TVscreenInfo.panel.MAIN.data.length) ;
					}catch(err){
						vue.$data.TVscreenInfo.panel.MAIN.bar = bar ;
	 					vue.$data.TVscreenInfo.panel.MAIN.content = content ;
	 					vue.$data.TVscreenInfo.panel.MAIN.item = item ;
	 					vue.$data.TVscreenInfo.panel.MAIN.id = id_1 ;
	 					vue.$data.TVscreenInfo.showControl[position][id] = control ;
	 					layer.close(sid)
	 					
	 					layer.open({
						  title: '错误'
						  ,content: '删除失败'
						});     
						return ;
					}
					layer.close(sid)
				}, function(index){
					 return ;
			})
		}else if(type == "VUELOGO"){
			vue.$data.TVscreenInfo.panel["VUELOGO"].img = undefined ;
			vue.$data.TVscreenInfo.panel["VUELOGO"].id = undefined ;
			vue.$data.TVscreenInfo.showControl[position][id] = false ;
		}else if(type == "VUEPMD"){
			vue.$data.TVscreenInfo.panel["VUEPMD"].id = undefined ;
			vue.$data.TVscreenInfo.panel["VUEPMD"].title = "" ;
			vue.$data.TVscreenInfo.panel["VUEPMD"].dirction = "" ;
			vue.$data.TVscreenInfo.panel["VUEPMD"].color = "" ;
			vue.$data.TVscreenInfo.showControl[position][id] = false ;
		}else if(type == "VUECLOCK"){
			vue.$data.TVscreenInfo.panel["VUECLOCK"] = {} ;
			vue.$data.TVscreenInfo.showControl[position][id] = false ;
		}
	})
}

//选apk时鼠标移上的事件
function apkHover(e){
	e.style.background = "#dfdfdf" ;
}

//选apk时鼠标移出事件
function apkOut(e){
	e.style.background = "none" ;
}

//选择apk事件
function apkSelect(index){
	layer.close(apkPanel) ;
	vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item == undefined ? 0 : vue.$data.TVscreenInfo.panel.MAIN.item].data.info[vue.$data.editeEl["content_item"]].apkName = vue.$data.apks[index].apkName ;
	vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item == undefined ? 0 : vue.$data.TVscreenInfo.panel.MAIN.item].data.info[vue.$data.editeEl["content_item"]].apk = vue.$data.apks[index].packageUrl ;
	vue.$data.TVscreenInfo.panel.MAIN.data[vue.$data.TVscreenInfo.panel.MAIN.item == undefined ? 0 : vue.$data.TVscreenInfo.panel.MAIN.item].data.info[vue.$data.editeEl["content_item"]].packageName = vue.$data.apks[index].packageName
}

$("#cxcolor td").click(function(){
	if(vue.$data.editeEl["type"] == "MAIN" && vue.$data.editeEl["content_item"] != undefined && typeof(vue.$data.editeEl["content_item"]) != "undefined"){
		vue.$data.TVscreenInfo.panel.border = this.title ;
	}else{
		vue.$data.TVscreenInfo.panel.color = this.title ;
	}
	$("#cxcolor").css("display" , "none") ;
})

//屏幕大小发生改变时
window.onresize = function(){
	vue.TVscreenInfo.width = document.querySelector(".main_TV_panel").offsetWidth ;
	vue.TVscreenInfo.height = document.querySelector(".main_TV_panel").offsetHeight ;
	vue.height = $(document).height() ;
}

//监听esc按键，实现退出预览功能
window.onkeyup = function(e){
	if(e.keyCode == 27){ //退出预览
		vue.$data.debug = false ;
	}
}
