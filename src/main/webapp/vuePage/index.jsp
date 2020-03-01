<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
	<meta charset="utf-8" />
    
    <title>woos 沃视tv编辑器</title>
	<style>
		*{margin:0px;padding:0px;}
		html,body{
			width:100%;height:100%;
		}
		#app{
			width:100%;
		}
		#vue-drag-content{
		 	width:100%;
		  	height:100%;
			display:flex;
			border:0px;
			background:gray ;
		}
		#vue-drag-content .select-item{
			width:4px;
			cursor:w-resize ;
		}
		#vue-drag-content .center{
			flex-grow: 1;
			display:flex;
			flex-direction: column;
		}
		#vue-drag-content .panel{
			height:100%;
			display:flex;
		}
		.vue-panel-content{
			border:1px solid #c8c4c4;
			width:100%;
			height:99%;
			overflow:auto;
		}
		.vue-panel-top{
			height:25px;
			line-height:25px;
			color:white;
			font-size:13px ;
			background:#5f5f5f;
			font-family: "楷体";
			border-bottom:1px solid #f0fffa;
			cursor:pointer;
		}
		.content_img:hover{
			border:1px solid red;
		}
		.vue-panel{position:absolute;}
		/*

		*/

		.layer-skin-mouse-right-menu .layui-layer-content {
			overflow-x: hidden !important;
		}
		
		.layer-skin-mouse-right-menu{
			border-radius: 5px !important;
			width:50px;
		}
		
		.mouse-right-menu {
			padding: 5px 0;
		}
		
		.mouse-right-menu .enian_menu .text {
			width: 100%;
			margin-left: 10px;
			line-height: 40px;
		}
		
		.mouse-right-menu .enian_menu {
			width: 100%;
			height: 40px;
			border-bottom: 1px solid #eee;
		}
		.mouse-right-menu .enian_menu:last-child{ 
			border-bottom:none;
		}
		.mouse-right-menu .enian_menu:hover {
			cursor: pointer;
			/*background: #009688;*/
			background: #696969;
			color: white;
		}
	</style>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" href="./js/layui/css/layui.css">
	<!-- 引入样式 -->
	<link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <script type="text/javascript" src="./js/jquery-1.11.0.min.js"></script>
    <script src="./js/layui/layui.js"></script>
    <!-- 引入右键菜单插件 -->
    <script src="./js/mouseRightMenu/mouseRightMenu.js"></script>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>
  
  <body>
  	<div style="width:100%;height:50px;background:#323232;display:flex;justify-content:space-between;"><div style="width:200px;height:50px;line-height:50px;font-size:18px;color:white;margin-left:10px;">沃视电视界面编辑器</div><div style="width:100px;height:50px;color:white;line-height:50px;">语言:
<select id="lang" name="language" lay-verify="" onchange="language(this)">
  <c:if test="${language == 'CN' }">
  	<option value="CN" selected="true">中文</option>
  </c:if>
  <c:if test="${language != 'CN' }">
  	<option value="CN">中文</option>
  </c:if>
  <c:if test="${language == 'EN' }">
  	<option value="EN" selected="true">英文</option>
  </c:if>
  <c:if test="${language != 'EN' }">
  	<option value="EN">英文</option>
  </c:if>
</select> </div></div>
    <div id="app" :style="{cursor:cursor,height:(height - 77) + 'px'}">
		<!-- 加上防拖拽事件 -->
		<div id="vue-drag-content" @mousemove="item_click_move($event)" @mouseup="item_click_up()" ondragstart="window.event.returnValue=false;return false;" oncontextmenu="window.event.returnValue=false;return false;" onselectstart="event.returnValue=false;return false;">
		  <div :style="{width:this.left+'px' , display:debug ? 'none' : 'flex'}">
				<div class="vue-panel-content">
					<div v-for="(item,index) in this.componentItems">
						<div @click="openOne(index)" class="vue-panel-top">{{item.name}}</div>
						<div v-if="TVscreenInfo.items[index]" style="display:flex;flex-direction:column;background:gray;">
							<div @mousedown="componentClick($event , i.type , i.id)" :title="i.msg" v-for="i in item.list" class="vue-component" :style="{width:i.width,height:i.height,margin:'0px auto'}">
								<img style="width:100%;height:100%;" :src="i.img" />
							</div> 
						</div>
					</div>
				</div>
			</div>
			<div :style="{display:debug ? 'none' : 'flex'}" @mousedown="item_click_down($event , 1)" class="select-item-left select-item"></div>
			<div class="center panel" style="border-radius:10px;overflow:hidden;">
				<div class="vue-panel-content" style="border-radius:10px;">
					<div style="">
						<div class="main_TV_panel" @mouseup="insert($event)" @mousemove="panelMove($event)" style="width:100%;border-radius:10px;overflow:hidden;position:relative;top:0px;" :style="{height:debug ? '100%' : (height - 180)*0.8 + 'px'}">
							<img style="width:100%;height:100%;z-index:1;position:absolute;top:0px;display:block;" :src="TVscreenInfo.panel.BG.img" />
							<div v-if="!TVscreenInfo.panel.BG.flag" @click="bg_change()" style="background:gray;width:80%;height:60%;border:dotted;z-index:10;position:absolute;text-align:center;font-size:18px;color:white;cursor:pointer;" :style="{top:TVscreenInfo.height/2-TVscreenInfo.height*0.6/2+'px',left:TVscreenInfo.width/2-TVscreenInfo.width*0.8/2+'px',lineHeight:TVscreenInfo.height*0.6+'px'}">点击选择电视机背景图</div>
							<c:forEach items="${list }" var="item">
								<div pos = "${item.msg }" class="vue-panel" type="${item.type }" pid="${item.id }" :style="{zIndex:2,width:${item.width },height:${item.height },${item.position.keySet().toArray()[0] }:${item.position.get(item.position.keySet().toArray()[0]) },${item.position.keySet().toArray()[1] }:${item.position.get(item.position.keySet().toArray()[1]) }}">
									<c:forEach items="${components }" var="i">
										<c:forEach items="${i.positions }" var="j">
											<c:if test="${j.name==item.id }">
												<<c:out value="${i.name }"></c:out> pos="${item.msg }" oncontextmenu="deleteComponent('${item.id }' , '${i.id }' , '${item.type }')" v-if="TVscreenInfo.showControl['${item.id }']['${i.id }']" :data="TVscreenInfo.panel" ref="${ i.name }"  v-on:click.stop="" :now="this.editeEl" :fields="fields"></<c:out value="${i.name }"></c:out>>
											</c:if>
										</c:forEach>
									</c:forEach>
								</div>
							</c:forEach>
						</div>
					</div>
					<div class="main_TV_save" style="display:flex;" :style="{height:debug ? '0px' : (height - 180)*0.2,display:debug ? 'none' : 'flex'}">
						<div style="width:50%;align-items:center;justify-content:center;display:flex;">
							<div class="layui-btn layui-btn-primary" style="width:160px;height:40px;text-align:center;font-size:16px;line-height:40px;" @click="save()">保存</div>
						</div>
						<div style="width:50%;align-items:center;justify-content:center;display:flex;">
							<div class="layui-btn layui-btn-primary" @click="fullScreen()" style="width:160px;height:40px;text-align:center;font-size:16px;line-height:40px;">预览</div>
						</div>
					</div>
				</div>
			</div>
			<div :style="{display:debug ? 'none' : 'flex'}" @mousedown="item_click_down($event , 2)" class="select-item-right select-item"></div>
			<div class="right panel" :style="{width:this.right+'px' , display:debug ? 'none' : 'flex'}">
				<div class="vue-panel-content">
					<div class="vue-size">
						<!-- 右侧属性编辑组件放置区域 -->
					</div>
				</div>
			</div>
		</div>
		<input type="file" style="display:none;" id="file" onchange="selectFile()" />
		<div style="display:none;" id="video"></div>
	</div>
	<div id="load" style="position:fixed;background:white;width:100%;height:100%;top:0px;left:0px;z-index:99999;"></div>
  </body>
	<script src="./js/vue.min.js"></script>
	<script src="./js/spark-md5.min.js"></script>
	<script src="https://unpkg.com/element-ui/lib/index.js"></script>
	<script src="./js/fields.js"></script>
 	<script>
		/**
		 * 预定义部分全局的变量
		 */
		var global = {
			"temp":false ,
			"id":${id} ,  //当前电视id
			"language":"${language}",  //当前编辑语种
			"apks":"http://woosyun.com:8080/api/getapk" //apk的接口
		} 
		var bgImg = "img/bgImg.png" ;
		//后台渲染，进行组件注册
		var array = ${array} ; //组件的详细信息
		var init = ${init} ; //组件初始状态(主要控制组件是否显示)
		<c:forEach items="${components}" var="item">
			//注册组件
			Vue.component("${item.name}" , ${item.code}) ;
		</c:forEach>
		var vue = new Vue({
			el:"#app",
			data:function () {
			    return {
						left:180,
						right:180,
						height:$(document).height() ,
						isChange:undefined , //监听页面是否发生变化
						debug:false ,
						flag:false , //表示鼠标是否点中拖动栏
						item:0 ,
						file:"" , //选择的文件
						name:"" , //视频文件名字
						color:"" , 
						fun:function(){console.log("未知错误")} ,  //选择文件时执行的回调函数
						temp:"" ,
						//右侧属性编辑的绑定数据
						fields:{
							0:true, //背景设置
							1:false , //文字编辑
							2:false , //图片选择
							3:false ,  //内容组件中图,apk选择
							4:false , //导航栏属性编辑
							5:false , //视频文件选择 
							6:false , //类容组件卡片类型
							7:true , // 边角设置
						} , //属性编辑器
						apks:[
						] , //apk的数据，仓库中可选apk
						screenWidth:500 ,
						cursor:"default" ,
						current:{} , //当前所拖动组件的详细信息
						editeEl:{type:undefined , id:undefined , content_item:undefined , bar_item:undefined} , //当前正在编辑的组件
						TVscreenInfo:{
							//bg:bgImg ,//"https://t12.baidu.com/it/u=2897648120,2717953286&fm=76", 	//电视大的背景图
							width:0 ,
							height:0 ,  //编辑区分辨率
							isBg:false ,  //是否已经设置背景
							isTorBar:false, //是否设置导航栏
							isTq:false , //是否设置天气控件
							isContent:false , //是否设置内容控件
							isLogo:false , //是否设置logo
							torBarPosition:0 , // 导航栏位置 0表示未设置，1表示顶部 ， 2表示侧边 ， 3表示底部
							panel:{
								"color":"black" ,  //全局的颜色
								"border":"red" ,
								"BG":{     //电视机背景
									"img":bgImg ,
									"flag":false 
								} ,
								"VUELOGO":{
									"id":undefined , //所设置的组件id
									"img":"./img/image.png"  //logo只能放图片 ， 默认图标
								} ,
								"MAIN":{
									"id":undefined , 
									"item":undefined , // 导航栏当前选中的项
									"bar":false , //是否设置导航栏
									"pos":"" ,
									"content":false , //是否设置内容组件
									"type":"" , // 导航栏位置信息
									data:[]
								} ,  //内容组件与导航栏合并
								"VUEPMD":{
									"id":undefined, //跑马灯的id
									title:"" ,	//跑马灯的内容
									size:"s" ,	//跑马灯的大小
									dirction:"r" ,	//跑马灯的方向r表示向右
									"color":"red" ,	//跑马灯的字体颜色
									"pos":"" ,		//跑马灯的相对位置
									bkcolor:"none" ,
									speed:"s" 
								} ,
								"VUECLOCK":{
									"id":undefined 
								}  ,
								"BORDER":{
									type:"rect" ,
									color:"none"
								}
							} ,		//已在面板上设置的组件
							//页面左侧组件展开控制数据
							items:[true , false , false , false , false] ,
							//控制中间面板中组件的现实与隐藏
							showControl:init , //控制各个组件是否显示		
						} ,
						//页面左侧组件的绑定数据
						componentItems:[
							{name:"logo",list:array["VUELOGO"]},
							{name:"天气",list:array["VUECLOCK"]},
							{name:"导航栏",list:array["BAR"]} ,
							{name:"内容",list:array["CONTENT"]} ,
							{name:"跑马灯",list:array["VUEPMD"]}
						]
			    }
			  } ,
			  watch:{
				  	//当右侧文件选择发生改变时，给页面中指定参数赋值
			  		file:function(n , o){
			  			if(this.editeEl.type == "VUELOGO"){
			  				this.TVscreenInfo.panel.VUELOGO.img = n ;
			  			}
			  			if(this.editeEl.type == "MAIN"){
			  				if(this.TVscreenInfo.panel.MAIN.bar){
			  					this.TVscreenInfo.panel.MAIN.data[this.TVscreenInfo.panel.MAIN.item][this.editeEl.content_item].img = n ;
			  				}else{
			  					this.TVscreenInfo.panel.MAIN.data[0][this.editeEl.content_item].img = n ;
			  				}
			  			}
			  		} ,
			  		color:function(n , o){
			  			if(this.editeEl.type == "VUEPMD"){
			  				this.TVscreenInfo.panel.VUEPMD.color = n ;
			  			}
			  		} ,
			  		//监听用户点击导航栏的哪一项
			  		"TVscreenInfo.panel.MAIN.item":function(n , o){
			  			//将所有的内容组件隐藏
			  			for(var i in this.TVscreenInfo.showControl[5]){
			  				if(i*1){
			  					this.TVscreenInfo.showControl[5][i] = false ;
			  				}
			  			}
			  			if(n == undefined || typeof(n) == "undefined" || this.TVscreenInfo.panel.MAIN.data[n] == undefined || typeof(this.TVscreenInfo.panel.MAIN.data[n]) == "undefined"){
			  				return ;
			  			}
			  			if(this.TVscreenInfo.panel.MAIN.data[n].data == undefined || typeof(this.TVscreenInfo.panel.MAIN.data[n].data) == "undefined" || this.TVscreenInfo.panel.MAIN.data[n].data.length == 0){
			  				this.TVscreenInfo.panel.MAIN.content = false ;
			  				return ;
			  			}else{
			  				this.TVscreenInfo.panel.MAIN.content = true ;
			  			}
			  			//将当前点击的内容组件显示
			  			this.TVscreenInfo.showControl[5][this.TVscreenInfo.panel.MAIN.data[n].data.id] = true ;
			  		} ,
			  		//控制右侧属性栏显示与隐藏
			  		"editeEl.type":function(n , o){
			  			//将当前所点击的组件属性栏打开
			  			var m = {"VUEPMD":1} ;
						for(var i in this.fields){
							if(i*1 == 0 || i*1 == 7){
								this.fields[i] = true ;
							}else{
								this.fields[i] = false ;
							}
						}
						if(n != "MAIN"){
							this.fields[m[n]] = true ;
						}else{
							if(typeof(this.editeEl["bar_item"]) != "undefined" && this.editeEl["bar_item"] != undefined){
								this.fields[4] = true ;
							}else if(this.editeEl["content_item"] != "undefined" && this.editeEl["content_item"] != undefined){
								this.fields[3] = true ;
								this.fields[5] = true ;
								this.fields[6] = true ;
							}
						}
			  		} ,
    				deep: true 
			  } ,
			  methods:{
				  //此编辑器的左右拉动事件
					item_click_down:function(e , item){
						if(!this.flag){
							this.item = item ;
							this.flag = true ;
						}
					} ,
					//左右拉的一个事件
					item_click_move:function(e){
						if(this.flag){
							if(this.item == 1){
								if(e.pageX <= 100){
									return ;
								}
								this.left = e.pageX ;
							}else if(this.item == 2){
								if(this.screenWidth - e.pageX <= 100){
									return ;
								}
								this.right = this.screenWidth - e.pageX ;
							}
						}
					} ,
					//左右拉的一个事件
					item_click_up:function(){
						this.flag = false ;
						this.cursor = "default" ;
					} ,
					//展开左侧的一项组件
					openOne:function(index){
						var len = this.TVscreenInfo.items.length ;
						for(var i=0 ; i<len ; i++){
							this.TVscreenInfo.items.splice(i , 1 , false) ;
						}
						this.TVscreenInfo.items[index] = true ;
					} ,
					//编辑好以后保存数据
					save:function(){
						var self = this ;
						if(this.isChange){
							if(!this.TVscreenInfo.panel.MAIN.content ){
								layui.use('layer', function(){
								  var layer = layui.layer;
								  
								  layer.msg('请选择内容组件', {icon: 5});
								}); 
								return
							}
							// 1.判断ppt项是否需要保留
							for(var i in this.TVscreenInfo.panel.MAIN.data){
								for(var j in this.TVscreenInfo.panel.MAIN.data[i].data.info){
									if(this.TVscreenInfo.panel.MAIN.data[i].data.info[j].packageName != "com.woos.ppt"){
										this.TVscreenInfo.panel.MAIN.data[i].data.info[j].ppt = []
									}
								}
							}
							//在真正保存前进行一次md5验证，可减轻服务器压力，相同文件可做到一次上传多次使用
							var spark = new SparkMD5();
							//var md5 = spark.append(base64).end() ;
							var md5 = {} ;
							//遍历界面中所有图片，找出新添加的图片
							//1.找背景
							if(this.TVscreenInfo.panel.BG.img != undefined && typeof(this.TVscreenInfo.panel.BG.img) != "undefined"){
								if(this.TVscreenInfo.panel.BG.img.startsWith("data:image/")){
									var m = spark.append(this.TVscreenInfo.panel.BG.img).end() ;
									md5["self.TVscreenInfo.panel.BG.img"] = m ;
								}
							}
							//将logo中的图片找出来
							if(this.TVscreenInfo.panel.VUELOGO.img != undefined && typeof(this.TVscreenInfo.panel.VUELOGO.img) != "undefined"){
								if(this.TVscreenInfo.panel.VUELOGO.img.startsWith("data:image/")){
									var m = spark.append(this.TVscreenInfo.panel.VUELOGO.img).end() ;
									md5["self.TVscreenInfo.panel.VUELOGO.img"] = m ;
								}
							}
							//将导航栏中所有的图片找出来
							if(this.TVscreenInfo.panel.MAIN.data != undefined && typeof(this.TVscreenInfo.panel.MAIN.data) != "undefined"){
								for(var i in this.TVscreenInfo.panel.MAIN.data){
									if(this.TVscreenInfo.panel.MAIN.data[i].img != undefined && typeof(this.TVscreenInfo.panel.MAIN.data[i].img) != "undefined"){
										if(this.TVscreenInfo.panel.MAIN.data[i].img.startsWith("data:image/")){
											var m = spark.append(this.TVscreenInfo.panel.MAIN.data[i].img).end() ;
											md5["self.TVscreenInfo.panel.MAIN.data["+i+"].img"] = m ;
										}
									}
									if(this.TVscreenInfo.panel.MAIN.data[i].selectedImg != undefined && typeof(this.TVscreenInfo.panel.MAIN.data[i].selectedImg) != "undefined"){
										if(this.TVscreenInfo.panel.MAIN.data[i].selectedImg.startsWith("data:image/")){
											var m = spark.append(this.TVscreenInfo.panel.MAIN.data[i].selectedImg).end() ;
											md5["self.TVscreenInfo.panel.MAIN.data["+i+"].selectedImg"] = m ;
										}
									}
									//将内容组件中所有的图片找出来
									if(this.TVscreenInfo.panel.MAIN.data[i].data != undefined && typeof(this.TVscreenInfo.panel.MAIN.data[i].data) != "undefined"){
										for(var j in this.TVscreenInfo.panel.MAIN.data[i].data.info){
											for(var n in this.TVscreenInfo.panel.MAIN.data[i].data.info[j].imgs){
												if(this.TVscreenInfo.panel.MAIN.data[i].data.info[j].imgs[n] != undefined && typeof(this.TVscreenInfo.panel.MAIN.data[i].data.info[j].imgs[n]) != "undefined"){
													if(this.TVscreenInfo.panel.MAIN.data[i].data.info[j].imgs[n].startsWith("data:image/")){
														var m = spark.append(this.TVscreenInfo.panel.MAIN.data[i].data.info[j].imgs[n]).end() ;
														md5["self.TVscreenInfo.panel.MAIN.data["+i+"].data.info["+j+"].imgs["+n+"]"] = m ;
													}
												}
											}
										}
									}
								}
							}
							var result = "" ;
							//进行md5校验
							$.ajax({
								url:"md5Check" ,
								type:"POST" ,
								data:{data:JSON.stringify(md5)} ,
								async:false ,
								success:function(res){
									result = res ;
								} ,
								error:function(){
									layer.msg("验证失败，请检查网络是否通畅", {icon: 5});
								}
							}) ;
							if(result == ""){
								return ;
							}else{
								layer.msg(result.msg , {icon: 5});
								for(var i in result.data){
									if(result.data[i] != "404" || result.data[i] != 404){
										eval(result.data[i]) ;
									}
								}
							}
							$.ajax({
								url:"pageUpload" ,
								type:"POST" ,
								data:{language:global.language , id:global.id , code:JSON.stringify(this.TVscreenInfo)} ,
								success:function(res){
									if(res.code == 500){
										layer.msg("【faild】"+res.msg, {icon: 5});
									}else if(res.code == 200){
										layer.msg("【success】"+res.msg, {icon: 5});
										self.isChange = false ;
										window.onbeforeunload = null ;
									}
								} ,
								error:function(){
									layer.msg("上传失败", {icon: 5});
								}
							})
						}else{
							layer.msg("【success】上传成功", {icon: 5});
						}
					} ,
					//全屏，预览模式
					fullScreen:function(){
						this.debug = true ;
						layer.msg('按ESC按钮退出', {icon: 5});
					} , 
					//向内容组件，导航栏组件中添加图片
					addImg:function(value){
						var self = this ;
						this.fun = function(base64){
							if(!base64.startsWith("data:image/")){
								layer.alert("只支持图片") ;
								return ;
							}
							if(value == "content"){
								if(self.TVscreenInfo.panel.MAIN.bar){
			 						self.TVscreenInfo.panel.MAIN.data[self.TVscreenInfo.panel.MAIN.item].data.info[self.editeEl["content_item"]].imgs.push(base64) ;
			 					}else{
			 						self.TVscreenInfo.panel.MAIN.data[0].data.info[self.editeEl["content_item"]].imgs.push(base64) ;
			 					}
							}else if(value == "bar_add"){
								if(self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img == "" || self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img == undefined || typeof(self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img) == "undefined"){
									self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img = base64 ;
								}else{
									self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].selectedImg = base64 ;
								}
							}else if(value == "bar_change"){
								self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img = base64 ;
							}
						}
						$("#file").click() ;
						this.$forceUpdate()
					} ,
					//鼠标左右键事件
					leftmenu:function (index){
						var data = {content:$(this).html()}
			 			var menu_data=[
							{'data':data,'type':1,'title':'删除'},
							{'data':data,'type':2,'title':'修改'}
						]
						var self = this ;
			 			global.mouseRightMenu.open(menu_data,false,function(d){
			 				if(d.type == 1){
			 					if(self.TVscreenInfo.panel.MAIN.bar){
			 						self.TVscreenInfo.panel.MAIN.data[self.TVscreenInfo.panel.MAIN.item].data.info[self.editeEl["content_item"]].imgs.splice(index , 1) ;
			 					}else{
			 						self.TVscreenInfo.panel.MAIN.data[0].data.info[self.editeEl["content_item"]].imgs.splice(index , 1) ;
			 					}
			 				} else if(d.type == 2){
								self.fun = function(base64){
									if(!base64.startsWith("data:image/")){
										layer.alert("只支持图片") ;
										return ;
									}
									if(self.TVscreenInfo.panel.MAIN.bar){
				 						self.TVscreenInfo.panel.MAIN.data[self.TVscreenInfo.panel.MAIN.item].data.info[self.editeEl["content_item"]].imgs.splice(index , 1 , base64) ;
				 					}else{
				 						self.TVscreenInfo.panel.MAIN.data[0].data.info[self.editeEl["content_item"]].imgs.splice(index , 1 , base64) ;
				 					}
								}
								$("#file").click() ; 
			 				}
			 			})
						return false;
					} ,
					//清除当前正在编辑数据
					clear:function(){
						for(var i in this.editeEl){
							this.editeEl[i] = undefined ;
						}
					} ,
					//背景切换
					bg_change:function(){
						var self = this ;
						this.fun = function(base64){
							if(!base64.startsWith("data:image/") && !base64.startsWith("data:vedio/")){
								layer.alert("只支持图片") ;
								return ;
							}
							self.TVscreenInfo.panel.BG.flag = true ;
							self.TVscreenInfo.panel.BG.img = base64 ;
						}
						$("#file").click() ;
					} ,
					panelMove:function(){
						//1.找出所有class为vue-panel的标签
						var list = document.querySelectorAll(".vue-panel") ;
						if(typeof(this.current.type) != "undefined" && typeof(this.current.id) != "undefined"){
							//遍历所有的标签，获取可以放置的位置
							for(var i=0 ; i<list.length ; i++){
								if(typeof(this.TVscreenInfo.showControl[list[i].getAttribute("pid")*1][this.current.id]) != "undefined"){
									list[i].style.border = "0.5px dashed green" ;
									list[i].style.background = "#83c46e6e"
								}
							}
						}
					} ,
					componentClick:function(e , type , id){
						this.cursor = "cell" ;
						this.current["type"] = type ;
						this.current["id"] = id ;
					},
					insert:function(e){
						var left = e.pageX - this.left - 6 ;
						var top = e.pageY - 50 - 1 ;
						this.cursorOn(top , left) ;
						this.current = {} ;
						var list = document.querySelectorAll(".vue-panel") ;
						for(var i=0 ; i<list.length ; i++){
							list[i].style.border = "none" ;
							list[i].style.background = "none" ;
						}
					},
					cursorOn:function(top , left){
						//1.找出所有class为vue-panel的标签
						var list = document.querySelectorAll(".vue-panel") ;
						//2.找出当前位置在哪几个标签的上方
						var now = [] ;
						for(var i=0 ; i<list.length ; i++){
							if(left > list[i].offsetLeft && top > list[i].offsetTop && top < list[i].offsetTop+list[i].clientHeight && left < list[i].offsetLeft+list[i].clientWidth){
								if(typeof(this.current.type) != "undefined" && typeof(this.current.id) != "undefined"){
									if(typeof(this.TVscreenInfo.showControl[list[i].getAttribute("pid")][this.current.id]) == "undefined"){
										break ;
									}
									if(this.current.type == "CONTENT"){
										if(this.TVscreenInfo.panel["MAIN"].content){
											layui.use('layer', function(){
											  var layer = layui.layer;
											  
											  layer.msg('该类型组件只能有一个', {icon: 5});
											}); 
										}else{
											this.TVscreenInfo.showControl[list[i].getAttribute("pid")][this.current.id] = true ;
											if(this.TVscreenInfo.panel.MAIN.bar){
												this.TVscreenInfo.panel.MAIN.content = true ;
											}else{
												this.TVscreenInfo.panel.MAIN.content = true ;
												this.TVscreenInfo.panel.MAIN.bar = false ;
												//this.TVscreenInfo.panel.MAIN.item = 0 ;
											}
										}
										return ;
									}else if(this.current.type == "BAR"){
										if(this.TVscreenInfo.panel["MAIN"].bar){
											layui.use('layer', function(){
											  var layer = layui.layer;
											  
											  layer.msg('该类型组件只能有一个', {icon: 5});
											}); 
										}else{										
											this.TVscreenInfo.showControl[list[i].getAttribute("pid")][this.current.id] = true ;
											this.TVscreenInfo.panel["MAIN"]["id"] = this.current.id ;
											this.TVscreenInfo.panel.MAIN.content = true ;
											this.TVscreenInfo.panel.MAIN.bar = true ;
											var self = this ;
											window.setTimeout(function(){
												self.TVscreenInfo.panel.MAIN.item = 0 ;
											} , 20)
											this.TVscreenInfo.panel.MAIN.pos = list[i].getAttribute("pos") ;
										}
										return ;
									}else if(this.TVscreenInfo.panel[this.current.type]["id"] != undefined || typeof(this.TVscreenInfo.panel[this.current.type]["id"]) != "undefined"){
										layui.use('layer', function(){
										  var layer = layui.layer;
										  
										  layer.msg('该类型组件只能有一个', {icon: 5});
										}); 
										return ;
									}
									this.TVscreenInfo.showControl[list[i].getAttribute("pid")][this.current.id] = true ;
									this.TVscreenInfo.panel[this.current.type]["id"] = this.current.id ;
									this.TVscreenInfo.panel[this.current.type].pos = list[i].getAttribute("pos") ;
								}
								//console.log(list[i].getAttribute("type") != "CONTENT" && list[i].getAttribute("type") != "BAR")
								if(list[i].getAttribute("type") != "CONTENT" && this.editeEl["type"] == "MAIN" && (typeof(this.editeEl["content_item"]) != "undefined" || this.editeEl["content_item"] != undefined)){
									this.clear() ;
									return ;
								}else if(list[i].getAttribute("type") == "CONTENT" && this.editeEl["type"] != "MAIN"  && ( typeof(this.editeEl["bar_item"]) == "undefined" || this.editeEl["bar_item"] == undefined )){
									this.clear() ;
									return ;
								}else if(list[i].getAttribute("type") == "BAR" && this.editeEl["type"] != "MAIN"  && ( typeof(this.editeEl["content_bar"]) == "undefined" || this.editeEl["content_bar"] == undefined )){
									this.clear() ;
									return ;
								}
								//else if(list[i].getAttribute("type") != "BAR" && this.editeEl["type"] == "MAIN"){
								//	this.editeEl = {} ;
								//}
								else if((list[i].getAttribute("type") != "CONTENT" && list[i].getAttribute("type") != "BAR") || list[i].getAttribute("type") != this.editeEl["type"]){
									this.clear() ;
									return ;
								}
							}
						}
						this.clear() ;
					}
			  } ,
				created:function(){
					this.screenWidth = document.body.clientWidth ;
					var self = this ;
					window.onload = function(){
						var load = layer.load();
						self.TVscreenInfo.width = document.querySelector(".main_TV_panel").offsetWidth ;
						self.TVscreenInfo.height = document.querySelector(".main_TV_panel").offsetHeight ;
						self.height = $(document).height() ;
						layer.close(load) ;
						$("#load").css("display" , "none") ;
					}
				},
				//当组件发生更新时
				updated:function(){
					this.TVscreenInfo.width = document.querySelector(".main_TV_panel").offsetWidth ;
					this.TVscreenInfo.height = document.querySelector(".main_TV_panel").offsetHeight ;
				} ,
				beforeCreate:function(){
					vue = this ;
				}
			});	
		
		//采用jsonp形式处理返回数据
		function fun_id(code){
			var code_json = JSON.parse(code) ;
			if(code_json.panel.MAIN.item == undefined || typeof(code_json.panel.MAIN.item) == undefined){
				code_json.panel.MAIN.item = undefined ;
			}
			var d = code_json.showControl ;
			for(var i in init){
				for(var j in init[i]){
					if(d[i][j] == undefined){
						d[i][j] = init[i][j]
					}
				}
			}
			vue.$data.TVscreenInfo = code_json ;
			vue.$watch('TVscreenInfo.panel.MAIN.item', vue.itemListener, {
			    deep: true
			});
		}	
	</script>
	<script src="js/init.js"></script>
	<script src="js/event.js"></script>
	<script src="screen/${id }/${language }/screen.json?rand=${Math.random()}" ></script>
</html>
