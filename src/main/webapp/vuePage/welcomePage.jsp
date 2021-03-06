<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html>
	<head>
		<base href="<%=basePath%>">
		<meta charset="utf-8">
		<title>沃视欢迎界面编辑</title>
		<link rel="stylesheet" href="./js/layui/css/layui.css">
		<script src="./js/layui/layui.js"></script>
		<script src="./js/layui/layui.all.js"></script>
		<script src="js/vue.min.js"></script>
		<!-- 引入样式 -->
		<link rel="stylesheet" href="./css/elementui.min.css">
		<!-- 引入组件库 -->
		<script src="./js/elementui.min.js"></script>
		<script type="text/javascript" src="./js/jquery-1.11.0.min.js"></script>
		<!-- 引入右键菜单插件 -->
    	<script src="./js/mouseRightMenu/mouseRightMenu.js"></script>
		<style>
			*{
				margin:0px;
				padding:0px;
			}
			html,body{
				width:100%;
				height:100%;
			}
			#app{
				width:100%;
				height:100%;
			}
			#app-top{
				width:100%;
				height:50px;
				background:#323232;
			}
			#app-top .title{
				color:white;
				font-size:18px;
				margin-left:10px;
				line-height:50px;
				width:200px;
				float:left;
			}
			#app-bottom .app-left{
				height:100%;
			}
			#app-bottom .app-right{
				height:100%;
				border-left:1px solid black;
			}
			
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
	</head>
	<body>
		<div id="app">
			<div id="app-top">
				<div class="title">沃视欢迎界面编辑器</div>
				<div @click="save()" style="float:right;margin-right:10px;height:30px;line-height:30px;margin-top:10px;" class="layui-btn layui-btn-primary">保存</div>
			</div>
			<div id="app-bottom" style="display:flex;width:100%;" :style="{height:(height - 50)+'px'}">
				<div class="app-left" :style="{width:width*0.8+'px'}">
					<div style="width:100%;border:20px solid black;margin:0px auto;" :style="{height:(height - 90)+'px' , width:(width*0.8 - 100)+'px'}">
						<el-carousel v-if="TVscreenInfo.panel.BG.type == 'img'" style="z-index:-1;" :height="height - 50 - 20 + 'px'">
					      <el-carousel-item v-for="item in TVscreenInfo.panel.BG.url" :key="item">
					        <img style="width:100%;height:100%;" class="small" :src="item" />
					      </el-carousel-item>
					    </el-carousel>
						<!-- <img v-if="TVscreenInfo.panel.BG.type == 'img'" :src="TVscreenInfo.panel.BG.url" style="width:100%;height:100%;" /> -->
						<div v-if="TVscreenInfo.panel.BG.type == 'video'" style="width:100%;height:100%;">
							<video id="bg_video" style="width:100%;height:100%;object-fit:fill;" muted :src="TVscreenInfo.panel.BG.video" autoplay="autoplay"></video>
						</div>
						<div style="position:absolute;height:150px;" :style="{width:(width*0.8 - 100)+'px' , top:(TVscreenInfo.panel.TXT.position == 'top' ? 0.1*(height-150)+50 : TVscreenInfo.panel.TXT.position == 'center' ? (height - 150)/2 : (height - 200)) + 'px'}">
							<div style="width:97%;margin:0px auto;height:25px;">
								<input v-if="TVscreenInfo.panel.TXT.type == 'user_set'" v-model="TVscreenInfo.panel.TXT.value1" type="text" style="width:100%;height:100%;background-color:transparent;border:1px dashed white;" :style="{color:TVscreenInfo.panel.TXT.color}" />
								<div v-if="TVscreenInfo.panel.TXT.type == 'default'" style="width:100%;height:100%;display:flex;">
									<div :style="{color:TVscreenInfo.panel.TXT.color}" style="font-size:14px;line-height:25px;">尊敬的：</div>
								</div>
							</div>
							<div style="width:97%;margin:10px auto;height:110px;">
								<textarea v-if="TVscreenInfo.panel.TXT.type != 'none'" v-model="TVscreenInfo.panel.TXT.value2" style="resize:none;width:100%;height:100%;background-color:transparent;border:1px dashed white;" :style="{color:TVscreenInfo.panel.TXT.color}" ></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="app-right" :style="{width:(width*0.2 - 1)+'px'}" style="overflow:auto;">
					<div style="width:100%;height:30px;font-size:12px;text-align:center;background:#5f5f5f;color:white;line-height:30px;">属性栏</div>
					<div item_height="160" class="item" style="width:100%;height:30px;border-top:2px solid black;line-height:30px;background:#5f5f5f;color:white;font-size:12px;cursor:pointer;">
						<div style="width:40px;margin-left:10px;float:left;">背景</div>
						<img src="./img/right.png" style="display: block;width:25px;height:25px;float:right;margin:2.5px;" />
					</div>
					<div style="width:100%;height:0px;background:gray;transition:height 0.5s;overflow:hidden;">
						<div style="margin:15px 0px 0px 30px;font-size:12px;color:white;">类型</div>
						<div style="width:60px;margin:15px 0px 0px 50px;">
							<select v-model="TVscreenInfo.panel.BG.type" style="height:25px;" class="layui-input" name="city" lay-verify="required">
							  <option value="img">图片</option>
							  <option value="video">视频</option>
							</select>  
						</div>
						<div style="margin:15px 0px 0px 30px;font-size:12px;color:white;display:flex;">背景音乐<el-checkbox style="margin:-2px 20px;color:white;" v-model="canplay" >播放</el-checkbox></div>
						<div style="width:60px;margin:15px 0px 0px 50px;display:flex;">
							<div @click="music_select()" style="width:60px;height:25px;line-height:25px;text-align:center;" class="layui-btn layui-btn-primary">选择</div>
							<div @click="music_remove()" v-if="TVscreenInfo.panel.BG.mp3 != ''" style="width:60px;height:25px;line-height:25px;text-align:center;" class="layui-btn layui-btn-primary">删除</div>
						</div>
					</div>
					<div :item_height="TVscreenInfo.panel.BG.type == 'img' ? 150 : 100" class="item" style="width:100%;height:30px;border-top:2px solid black;line-height:30px;background:#5f5f5f;color:white;font-size:12px;cursor:pointer;">
						<div style="width:40px;margin-left:10px;float:left;">{{TVscreenInfo.panel.BG.type == 'img' ? "图片" : "视频"}}</div>
						<img src="./img/right.png" style="display: block;width:25px;height:25px;float:right;margin:2.5px;" />
					</div>
					<div style="width:100%;height:0px;background:gray;transition:height 0.5s;overflow:hidden;">
						<div style="margin:15px 0px 0px 30px;font-size:12px;color:white;">文件</div>
						<div style="width:100%;margin:15px 0px 0px 50px;display:flex;">
							<div @click="file_select()" style="width:60px;height:25px;line-height:25px;text-align:center;" class="layui-btn layui-btn-primary">{{TVscreenInfo.panel.BG.type == 'img' ? "新增" : "选择"}}</div>
						</div>
						<div v-if="TVscreenInfo.panel.BG.type == 'img'" style="width:100%;height:50px;margin:20px 0px 0px 10px;display:flex;">
							<div style="width:40px;height:40px;margin-left:5px;" v-for="(item , index) in TVscreenInfo.panel.BG.url">
								<img @contextmenu.prevent="leftmenu(index)" @click="leftmenu(index)" :src="item" style="width:100%;height:100%;" />
							</div>
						</div>
					</div>
					<div item_height="250" class="item" style="width:100%;height:30px;border-top:2px solid black;line-height:30px;background:#5f5f5f;color:white;font-size:12px;cursor:pointer;">
						<div style="width:40px;margin-left:10px;float:left;">文字</div>
						<img src="./img/right.png" style="display: block;width:25px;height:25px;float:right;margin:2.5px;" />
					</div>
					<div style="width:100%;height:0px;background:gray;transition:height 0.5s;overflow:hidden;">
						<div style="margin:15px 0px 0px 30px;font-size:12px;color:white;">位置</div>
						<div style="width:60px;margin:15px 0px 0px 50px;">
							<select v-model="TVscreenInfo.panel.TXT.position" style="height:25px;" class="layui-input" name="city" lay-verify="required">
							  <option value="top">上面</option>
							  <option value="center">中间</option>
							  <option value="bottom">底部</option>
							</select>  
						</div>
						<div style="margin:15px 0px 0px 30px;font-size:12px;color:white;">类型</div>
						<div style="width:85px;margin:15px 0px 0px 50px;">
							<select style="height:25px;" v-model="TVscreenInfo.panel.TXT.type" class="layui-input" name="city" lay-verify="required">
							  <option value="default">动态问候语</option>
							  <option value="user_set">自定义</option>
							  <option value="none">无</option>
							</select>  
						</div>
						<div style="margin:15px 0px 0px 30px;font-size:12px;color:white;">颜色</div>
						<div style="width:60px;margin:15px 0px 0px 50px;">
							<div id="color" style="width:60px;height:25px;line-height:25px;text-align:center;"></div>
						</div>
					</div>
				</div>
			</div>
			<input id="file" style="display:none;" type="file" onchange="selectFile()" />
			<div id="video_upload" style="display:none;"></div>
			<div id="audio_upload" style="display:none;"></div>
			<audio loop="true" id="bg_music" :src="TVscreenInfo.panel.BG.mp3"></audio>
		</div>
	</body>
	<script>
		var global = {}
		//使用右键菜单插件
		layui.config({base: './js/mouseRightMenu/'})
		layui.use(['mouseRightMenu','layer','jquery'],function(){
			global.mouseRightMenu = layui.mouseRightMenu,global.layer = layui.layer;	
		})
		
		var vue = new Vue({
			el:"#app" ,
			data:{
				width:document.querySelector("body").offsetWidth ,
				height:document.querySelector("body").offsetHeight ,
				fun:undefined ,
				canplay:false ,
				TVscreenInfo:{
					panel:{
						BG:{
							type:"img" ,
							url:["./img/woos.png"] ,
							video:"" ,
							mp3:""
						} , 
						TXT:{
							position:'top' ,
							color:'#ffffff' ,
							value1:'' ,
							value2:'' ,
							type:'default' ,
							inter:""
						}
					}
				}
			} ,
			watch:{
				"TVscreenInfo.panel.BG.type":function(n , o) {
					document.querySelectorAll(".item")[1].click()
					window.setTimeout(function(){
						document.querySelectorAll(".item")[1].click()
					} , 200)
				} ,
				canplay:function(n , o){
					if(this.canplay){
						document.getElementById("bg_music").play()
					}else{
						document.getElementById("bg_music").pause()
					}
				} ,
				deep:true
			} ,
			created(){
				
			} ,
			methods:{
				setUrl:function(){
					var self = this ;
					layui.use('layer', function(){
						var layer = layui.layer;
					  
						layer.open({
							content: '<input onblur="set_url(event)" placeholder="请输入接口地址，参数是电视id" value="'+self.TVscreenInfo.panel.TXT.inter+'" class="layui-input" type="text" >',
						});
					}); 
				} ,
				file_select:function(){
					var self = this ;
					if(this.TVscreenInfo.panel.BG.type == 'img'){
						this.fun = function(base64){
							self.TVscreenInfo.panel.BG.url.push(base64) ;
						}
						document.getElementById("file").click() ;
					}else{
						document.getElementById("video_upload").click() ;
					}
				} ,
				music_select:function(){
					document.getElementById("audio_upload").click() ;
				} ,
				music_remove:function(){
					this.TVscreenInfo.panel.BG.mp3 = "" ;
				} ,
				save:function(){
					var self = this ;
					layui.use(['jquery','layer'], function(){
						$ = layui.$  ;
						$.ajax({
							url:"<%= path%>/welcome_save" ,
							method:"POST" ,
							data:{code:JSON.stringify(self.TVscreenInfo),id:${id}} ,
							success:function(res){
								layer.msg("上传成功")
							} ,
							fail:function(){
								layer.msg("上传失败")
							}
						})
					});
				} ,
				//鼠标左右键事件
				leftmenu:function (index){
					var self = this 
					var data = {content:$(this).html()}
		 			var menu_data=[
						{'data':data,'type':1,'title':'删除'},
						{'data':data,'type':2,'title':'修改'}
					]
					var self = this ;
		 			global.mouseRightMenu.open(menu_data,false,function(d){
		 				if(d.type == 1){
		 					if(self.TVscreenInfo.panel.BG.url.length < 2) {
		 						alert("至少要有一张图片")
		 					}else{
		 						self.TVscreenInfo.panel.BG.url.splice(index , 1)
		 					}
		 				} else if(d.type == 2){
							self.fun = function(base64) {
								self.TVscreenInfo.panel.BG.url[index] = base64
								self.$forceUpdate()
							}
							document.getElementById("file").click() ;
		 				}
		 			})
					return false;
				} 
			}
		}) ;
		
		//屏幕大小发生改变时
		window.onresize = function(){
			vue.$data.width = document.querySelector("body").offsetWidth ;
			vue.$data.height = document.querySelector("body").offsetHeight ;
		}
		
		//给属性选项添加点击事件,控制某一个属性的展开和收拢
		$(".item").each(function(){
			var self = $(this)
			window.setTimeout(function(){
				self.find("img").attr("src" , "./img/down.png")
				self.find("img").css("margin-top" , "0px")
				self.next().css("height" , self.attr("item_height")+'px')
			} , 100)
			$(this).click(function(){
				var s = $(this).find("img").attr("src")+""
				if(s.indexOf("right.png") != -1){
					$(this).find("img").attr("src" , "./img/down.png")
					$(this).find("img").css("margin-top" , "0px")
					$(this).next().css("height" , $(this).attr("item_height")+'px')
				}else{
					$(this).find("img").attr("src" , "./img/right.png")
					$(this).find("img").css("margin-top" , "2.5px")
					$(this).next().css("height" , "0px")
				}
			})
		}) ;
		//颜色选择器
		layui.use('colorpicker', function(){
		  var colorpicker = layui.colorpicker;
		  //渲染
		  colorpicker.render({
		    elem: '#color' ,  
			size: 'sm' ,
			color:"#ffffff" ,
			done: function(color){
				vue.$data.TVscreenInfo.panel.TXT.color = color ;
			}
		  });
		});
		
		function set_url(event){
			vue.TVscreenInfo.panel.TXT.inter = event.srcElement.value ;
		}
		
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
		//视频文件上传
		layui.use('upload', function(){
		  var upload = layui.upload;
		   
		  //执行实例
		  var uploadInst = upload.render({
		    elem: '#video_upload' //绑定元素
		    ,url: '<%= path%>/upload' //上传接口
		    ,accept:"video"
		    ,size:1024*1024*1024*200 //200Mb
		    ,before: function(obj){ //obj参数包含的信息，跟 choose回调完全一致，可参见上文。
		        layer.load(); //上传loading
		    }
		    ,done: function(res){
		    	layer.closeAll('loading'); //关闭loading
		    	vue.$data.TVscreenInfo.panel.BG.video = res.data ;
		    }
		    ,error: function(){
		    	layer.closeAll('loading'); //关闭loading
		    }
		  });
		});
		
		//mp3文件上传
		layui.use('upload', function(){
		  var upload = layui.upload;
		   
		  //执行实例
		  var uploadInst = upload.render({
		    elem: '#audio_upload' //绑定元素
		    ,url: '<%= path%>/upload' //上传接口
		    ,accept:"audio"
		    ,size:1024*1024*20 //200Mb
		    ,before: function(obj){ //obj参数包含的信息，跟 choose回调完全一致，可参见上文。
		        layer.load(); //上传loading
		    }
		    ,done: function(res){
		    	layer.closeAll('loading'); //关闭loading
		    	vue.$data.TVscreenInfo.panel.BG.mp3 = res.data ;
		    }
		    ,error: function(){
		    	layer.closeAll('loading'); //关闭loading
		    }
		  });
		});
		
		function fun_id(code){
			var data = JSON.parse(code) ;
			vue.TVscreenInfo = data ;
		}
	</script>
	<script src="screen/${id}/welcome/welcome.json"></script>
</html>
