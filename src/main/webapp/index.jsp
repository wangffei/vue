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
			width:100%;height:100%;
		}
		#vue-drag-content{
		 	width:100%;
		  	height:100%;
			display:flex;
			border:0px;
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
		#vue-drag-content .center .main_TV_save{
			width:100%;
			height:20%;
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
			color:black;
			font-size:13px ;
			background:rgb(130, 231, 198);
			font-family: "楷体";
			border-bottom:1px solid rgb(130, 231, 198);
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
    <script type="text/javascript" src="./js/jquery-1.11.0.min.js"></script>
    <script src="./js/layui/layui.js"></script>
    <!-- 引入右键菜单插件 -->
    <script src="./js/mouseRightMenu/mouseRightMenu.js"></script>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
  </head>
  
  <body>
    <div id="app" :style="{cursor:cursor}">
		<!-- 加上防拖拽事件 -->
		<div id="vue-drag-content" @mousemove="item_click_move($event)" @mouseup="item_click_up()" ondragstart="window.event.returnValue=false;return false;" oncontextmenu="window.event.returnValue=false;return false;" onselectstart="event.returnValue=false;return false;">
		  <div class="left panel" :style="{width:this.left+'px'}">
				<div class="vue-panel-content">
					<div v-for="item in this.componentItems">
						<div class="vue-panel-top">{{item.name}}</div>
						<div style="display:flex;flex-direction:column;">
							<div @mousedown="componentClick($event , i.type , i.id)" :title="i.msg" v-for="i in item.list" class="vue-component" :style="{width:i.width,height:i.height,margin:'0px auto'}">
								<img style="width:100%;height:100%;" :src="i.img" />
							</div>
						</div>
					</div>
				</div>
			</div>
			<div @mousedown="item_click_down($event , 1)" class="select-item-left select-item"></div>
			<div class="center panel" style="border-radius:10px;">
				<div class="vue-panel-content" style="border-radius:10px;">
					<div class="main_TV_panel" @click="panelClick($event)" @mouseup="insert($event)" @mousemove="panelMove($event)" style="width:100%;height:80%;border-radius:10px;overflow:hidden;position:relative;top:0px;">
						<img style="width:100%;height:100%;z-index:1;position:absolute;top:0px;display:block;" :src="TVscreenInfo.panel.BG.img" />
						<div v-if="!TVscreenInfo.panel.BG.flag" @click="bg_change()" style="background:gray;width:80%;height:60%;border:dotted;z-index:10;position:absolute;text-align:center;font-size:18px;color:white;cursor:pointer;" :style="{top:TVscreenInfo.height/2-TVscreenInfo.height*0.6/2+'px',left:TVscreenInfo.width/2-TVscreenInfo.width*0.8/2+'px',lineHeight:TVscreenInfo.height*0.6+'px'}">点击选择电视机背景图</div>
						<c:forEach items="${list }" var="item">
							<div class="vue-panel" type="${item.type }" pid="${item.id }" :style="{zIndex:2,width:${item.width },height:${item.height },${item.position.keySet().toArray()[0] }:${item.position.get(item.position.keySet().toArray()[0]) },${item.position.keySet().toArray()[1] }:${item.position.get(item.position.keySet().toArray()[1]) }}">
								<c:forEach items="${components }" var="i">
									<c:forEach items="${i.positions }" var="j">
										<c:if test="${j.name==item.id }">
											<<c:out value="${i.name }"></c:out> v-if="TVscreenInfo.showControl['${item.id }']['${i.id }']" :data="'${item.type }'=='CONTENT' || '${item.type }'=='BAR' ? TVscreenInfo.panel['MAIN'] : TVscreenInfo.panel['${item.type }']" ref="${ i.name }"  v-on:click.stop="alert('123')" :now="this.editeEl" :fields="fields"></<c:out value="${i.name }"></c:out>>
										</c:if>
									</c:forEach>
								</c:forEach>
							</div>
						</c:forEach>
					</div>
					<div class="main_TV_save">
					</div>
				</div>
			</div>
			<div @mousedown="item_click_down($event , 2)" class="select-item-right select-item"></div>
			<div class="right panel" :style="{width:this.right+'px'}">
				<div class="vue-panel-content">
					<div class="vue-size">
						<!-- 电视机背景设置 -->
						<div v-if="fields[0]" style="width:100%;height:25px;background:#82e7c6;line-height:25px;padding-left:10px;">背景</div>
						<div v-if="fields[0]" style="width:100%;height:50px;overflow:hidden;">
							<div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">背景：<div @click="bg_change()" class="layui-btn layui-btn-xs">选择图片</div></div>
						</div>
						<!-- 文字属性设置 -->
						<div v-if="fields[1]" style="width:100%;height:25px;background:#82e7c6;line-height:25px;padding-left:10px;">文字</div>
						<div v-if="fields[1]" style="width:100%;height:160px;overflow:hidden;">
							<div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">大小：<input type="text" v-model="size" style="height:25px;width:60px;" /></div>
							<div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">内容：<input v-model="text" type="text" style="height:25px;width:60px;" /></div>
							<div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">颜色：<input readonly="readonly" type="text" style="height:25px;width:60px;cursor:pointer;border-top:8px solid black;border-bottom:8px solid black;" @click="colorSelet($event)" /></div>
						</div>
						<!-- 文件属性 -->
						<div v-if="fields[2]" style="width:100%;height:25px;background:#82e7c6;line-height:25px;padding-left:10px;">图片</div>
						<div v-if="fields[2]" style="width:100%;height:50px;overflow:hidden;">
							<div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">文件：<div @click="file_select()" class="layui-btn layui-btn-xs">选择图片</div></div>
						</div>
						<!-- 内容组件属性 -->
						<div v-if="fields[3]" style="width:100%;height:25px;background:#82e7c6;line-height:25px;padding-left:10px;">内容</div>
						<div v-if="fields[3]" style="width:100%;overflow:hidden;">
							<div style="display:flex;width:100%;padding-left:5px;padding:8px 5px;border-bottom:0.3px solid #dbdbdb;">应用：<div></div><div class="layui-btn layui-btn-xs layui-btn-normal">选择apk</div></div>
							<div style="display:flex;margin-top:5px;flex-wrap:wrap;">
								<div class="content_img" @contextmenu="leftmenu(index)" @click="leftmenu(index)" style="width:40px;height:40px;margin:5px 0px 0px 5px;" v-for="(img , index) in ((TVscreenInfo.panel.MAIN.bar ? TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].data.info[editeEl.content_item] : TVscreenInfo.panel.MAIN.data[0].data.info[editeEl.content_item]) == undefined || typeof((TVscreenInfo.panel.MAIN.bar ? TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].data.info[editeEl.content_item] : TVscreenInfo.panel.MAIN.data[0].data.info[editeEl.content_item])) == 'undefined') ? [] : (TVscreenInfo.panel.MAIN.bar ? TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].data.info[editeEl.content_item].imgs : TVscreenInfo.panel.MAIN.data[0].data.info[editeEl.content_item].imgs)"><img :src="img" style="width:40px;height:40px;cursor:pointer;display:block;" title="修改"></div>
							</div>
							<div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;margin-left:5px;"><button @click="addImg('content')" type="button" class="layui-btn layui-btn-xs layui-btn-primary" style="width:90%;">添加图片</button></div>
						</div>
						<!-- 导航栏组件属性 -->
						<div v-if="fields[4]" style="width:100%;height:25px;background:#82e7c6;line-height:25px;padding-left:10px;display:flex;"><div style="width:70%;">菜单</div><div class="layui-btn layui-btn-xs layui-btn-primary" style="width:50px;" @click="addBarItem()">添加</div></div>
						<div v-if="fields[4]" style="width:100%;overflow:hidden;">
							<div v-for="(item,index) in TVscreenInfo.panel.MAIN.data" style="display:flex;width:90%;padding-left:5px;flex-wrap:wrap;font-size:12px;line-height:25px;height:25px;color:gray;border:1px solid #91dbff;box-shadow:1px 1px 115px #e3e3e3;margin-top:3px;position:relative;" ><input v-model="item.name" style="width:70%;height:100%;border:0px;"><img src="./img/close.png" style="display:block;float:right;width:20px;height:20px;position:absolute;right:0px;cursor:pointer;" @click="removeBar(index)"></div>
						</div>
						<div v-if="fields[4]" style="width:100%;height:25px;background:#82e7c6;line-height:25px;padding-left:10px;">图标</div>
						<div v-if="fields[4]" style="width:100%;overflow:hidden;">
							<div v-if="$refs['v-bar_icon'].typeid == 'bar_icon'" style="display:flex;width:100%;padding-left:5px;flex-wrap:wrap;margin:5px;"><img style="width:40px;height:40px;" @click="addImg('bar_change')" v-if="TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].img != undefined && typeof(TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].img) != 'undefined' && TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].img != ''" :src="TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].img"><div style="width:40px;height:40px;line-height:40px;text-align:center;font-size:12px;color:white;background:gray;" v-if="TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].img == undefined || typeof(TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].img) == 'undefined' || TVscreenInfo.panel.MAIN.data[TVscreenInfo.panel.MAIN.item].img == ''"  @click="addImg('bar_change')">添加</div></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="cxcolor" style="display: none;top: 30px;position:fixed;right:400px;z-index:2000;"><table style="width:200px;height:180px;"><tbody><tr><td title="#000000" style="background-color:#000000"></td><td title="#000000" style="background-color:#000000"></td><td title="#000000" style="background-color:#000000"></td><td title="#000000" style="background-color:#000000"></td><td title="#003300" style="background-color:#003300"></td><td title="#006600" style="background-color:#006600"></td><td title="#009900" style="background-color:#009900"></td><td title="#00cc00" style="background-color:#00cc00"></td><td title="#00ff00" style="background-color:#00ff00"></td><td title="#330000" style="background-color:#330000"></td><td title="#333300" style="background-color:#333300"></td><td title="#336600" style="background-color:#336600"></td><td title="#339900" style="background-color:#339900"></td><td title="#33cc00" style="background-color:#33cc00"></td><td title="#33ff00" style="background-color:#33ff00"></td><td title="#660000" style="background-color:#660000"></td><td title="#663300" style="background-color:#663300"></td><td title="#666600" style="background-color:#666600"></td><td title="#669900" style="background-color:#669900"></td><td title="#66cc00" style="background-color:#66cc00"></td><td title="#66ff00" style="background-color:#66ff00"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#333333" style="background-color:#333333"></td><td title="#000000" style="background-color:#000000"></td><td title="#000033" style="background-color:#000033"></td><td title="#003333" style="background-color:#003333"></td><td title="#006633" style="background-color:#006633"></td><td title="#009933" style="background-color:#009933"></td><td title="#00cc33" style="background-color:#00cc33"></td><td title="#00ff33" style="background-color:#00ff33"></td><td title="#330033" style="background-color:#330033"></td><td title="#333333" style="background-color:#333333"></td><td title="#336633" style="background-color:#336633"></td><td title="#339933" style="background-color:#339933"></td><td title="#33cc33" style="background-color:#33cc33"></td><td title="#33ff33" style="background-color:#33ff33"></td><td title="#660033" style="background-color:#660033"></td><td title="#663333" style="background-color:#663333"></td><td title="#666633" style="background-color:#666633"></td><td title="#669933" style="background-color:#669933"></td><td title="#66cc33" style="background-color:#66cc33"></td><td title="#66ff33" style="background-color:#66ff33"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#666666" style="background-color:#666666"></td><td title="#000000" style="background-color:#000000"></td><td title="#000066" style="background-color:#000066"></td><td title="#003366" style="background-color:#003366"></td><td title="#006666" style="background-color:#006666"></td><td title="#009966" style="background-color:#009966"></td><td title="#00cc66" style="background-color:#00cc66"></td><td title="#00ff66" style="background-color:#00ff66"></td><td title="#330066" style="background-color:#330066"></td><td title="#333366" style="background-color:#333366"></td><td title="#336666" style="background-color:#336666"></td><td title="#339966" style="background-color:#339966"></td><td title="#33cc66" style="background-color:#33cc66"></td><td title="#33ff66" style="background-color:#33ff66"></td><td title="#660066" style="background-color:#660066"></td><td title="#663366" style="background-color:#663366"></td><td title="#666666" style="background-color:#666666"></td><td title="#669966" style="background-color:#669966"></td><td title="#66cc66" style="background-color:#66cc66"></td><td title="#66ff66" style="background-color:#66ff66"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#999999" style="background-color:#999999"></td><td title="#000000" style="background-color:#000000"></td><td title="#000099" style="background-color:#000099"></td><td title="#003399" style="background-color:#003399"></td><td title="#006699" style="background-color:#006699"></td><td title="#009999" style="background-color:#009999"></td><td title="#00cc99" style="background-color:#00cc99"></td><td title="#00ff99" style="background-color:#00ff99"></td><td title="#330099" style="background-color:#330099"></td><td title="#333399" style="background-color:#333399"></td><td title="#336699" style="background-color:#336699"></td><td title="#339999" style="background-color:#339999"></td><td title="#33cc99" style="background-color:#33cc99"></td><td title="#33ff99" style="background-color:#33ff99"></td><td title="#660099" style="background-color:#660099"></td><td title="#663399" style="background-color:#663399"></td><td title="#666699" style="background-color:#666699"></td><td title="#669999" style="background-color:#669999"></td><td title="#66cc99" style="background-color:#66cc99"></td><td title="#66ff99" style="background-color:#66ff99"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#cccccc" style="background-color:#cccccc"></td><td title="#000000" style="background-color:#000000"></td><td title="#0000cc" style="background-color:#0000cc"></td><td title="#0033cc" style="background-color:#0033cc"></td><td title="#0066cc" style="background-color:#0066cc"></td><td title="#0099cc" style="background-color:#0099cc"></td><td title="#00cccc" style="background-color:#00cccc"></td><td title="#00ffcc" style="background-color:#00ffcc"></td><td title="#3300cc" style="background-color:#3300cc"></td><td title="#3333cc" style="background-color:#3333cc"></td><td title="#3366cc" style="background-color:#3366cc"></td><td title="#3399cc" style="background-color:#3399cc"></td><td title="#33cccc" style="background-color:#33cccc"></td><td title="#33ffcc" style="background-color:#33ffcc"></td><td title="#6600cc" style="background-color:#6600cc"></td><td title="#6633cc" style="background-color:#6633cc"></td><td title="#6666cc" style="background-color:#6666cc"></td><td title="#6699cc" style="background-color:#6699cc"></td><td title="#66cccc" style="background-color:#66cccc"></td><td title="#66ffcc" style="background-color:#66ffcc"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#ffffff" style="background-color:#ffffff"></td><td title="#000000" style="background-color:#000000"></td><td title="#0000ff" style="background-color:#0000ff"></td><td title="#0033ff" style="background-color:#0033ff"></td><td title="#0066ff" style="background-color:#0066ff"></td><td title="#0099ff" style="background-color:#0099ff"></td><td title="#00ccff" style="background-color:#00ccff"></td><td title="#00ffff" style="background-color:#00ffff"></td><td title="#3300ff" style="background-color:#3300ff"></td><td title="#3333ff" style="background-color:#3333ff"></td><td title="#3366ff" style="background-color:#3366ff"></td><td title="#3399ff" style="background-color:#3399ff"></td><td title="#33ccff" style="background-color:#33ccff"></td><td title="#33ffff" style="background-color:#33ffff"></td><td title="#6600ff" style="background-color:#6600ff"></td><td title="#6633ff" style="background-color:#6633ff"></td><td title="#6666ff" style="background-color:#6666ff"></td><td title="#6699ff" style="background-color:#6699ff"></td><td title="#66ccff" style="background-color:#66ccff"></td><td title="#66ffff" style="background-color:#66ffff"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#ff0000" style="background-color:#ff0000"></td><td title="#000000" style="background-color:#000000"></td><td title="#990000" style="background-color:#990000"></td><td title="#993300" style="background-color:#993300"></td><td title="#996600" style="background-color:#996600"></td><td title="#999900" style="background-color:#999900"></td><td title="#99cc00" style="background-color:#99cc00"></td><td title="#99ff00" style="background-color:#99ff00"></td><td title="#cc0000" style="background-color:#cc0000"></td><td title="#cc3300" style="background-color:#cc3300"></td><td title="#cc6600" style="background-color:#cc6600"></td><td title="#cc9900" style="background-color:#cc9900"></td><td title="#cccc00" style="background-color:#cccc00"></td><td title="#ccff00" style="background-color:#ccff00"></td><td title="#ff0000" style="background-color:#ff0000"></td><td title="#ff3300" style="background-color:#ff3300"></td><td title="#ff6600" style="background-color:#ff6600"></td><td title="#ff9900" style="background-color:#ff9900"></td><td title="#ffcc00" style="background-color:#ffcc00"></td><td title="#ffff00" style="background-color:#ffff00"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#00ff00" style="background-color:#00ff00"></td><td title="#000000" style="background-color:#000000"></td><td title="#990033" style="background-color:#990033"></td><td title="#993333" style="background-color:#993333"></td><td title="#996633" style="background-color:#996633"></td><td title="#999933" style="background-color:#999933"></td><td title="#99cc33" style="background-color:#99cc33"></td><td title="#99ff33" style="background-color:#99ff33"></td><td title="#cc0033" style="background-color:#cc0033"></td><td title="#cc3333" style="background-color:#cc3333"></td><td title="#cc6633" style="background-color:#cc6633"></td><td title="#cc9933" style="background-color:#cc9933"></td><td title="#cccc33" style="background-color:#cccc33"></td><td title="#ccff33" style="background-color:#ccff33"></td><td title="#ff0033" style="background-color:#ff0033"></td><td title="#ff3333" style="background-color:#ff3333"></td><td title="#ff6633" style="background-color:#ff6633"></td><td title="#ff9933" style="background-color:#ff9933"></td><td title="#ffcc33" style="background-color:#ffcc33"></td><td title="#ffff33" style="background-color:#ffff33"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#0000ff" style="background-color:#0000ff"></td><td title="#000000" style="background-color:#000000"></td><td title="#990066" style="background-color:#990066"></td><td title="#993366" style="background-color:#993366"></td><td title="#996666" style="background-color:#996666"></td><td title="#999966" style="background-color:#999966"></td><td title="#99cc66" style="background-color:#99cc66"></td><td title="#99ff66" style="background-color:#99ff66"></td><td title="#cc0066" style="background-color:#cc0066"></td><td title="#cc3366" style="background-color:#cc3366"></td><td title="#cc6666" style="background-color:#cc6666"></td><td title="#cc9966" style="background-color:#cc9966"></td><td title="#cccc66" style="background-color:#cccc66"></td><td title="#ccff66" style="background-color:#ccff66"></td><td title="#ff0066" style="background-color:#ff0066"></td><td title="#ff3366" style="background-color:#ff3366"></td><td title="#ff6666" style="background-color:#ff6666"></td><td title="#ff9966" style="background-color:#ff9966"></td><td title="#ffcc66" style="background-color:#ffcc66"></td><td title="#ffff66" style="background-color:#ffff66"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#ffff00" style="background-color:#ffff00"></td><td title="#000000" style="background-color:#000000"></td><td title="#990099" style="background-color:#990099"></td><td title="#993399" style="background-color:#993399"></td><td title="#996699" style="background-color:#996699"></td><td title="#999999" style="background-color:#999999"></td><td title="#99cc99" style="background-color:#99cc99"></td><td title="#99ff99" style="background-color:#99ff99"></td><td title="#cc0099" style="background-color:#cc0099"></td><td title="#cc3399" style="background-color:#cc3399"></td><td title="#cc6699" style="background-color:#cc6699"></td><td title="#cc9999" style="background-color:#cc9999"></td><td title="#cccc99" style="background-color:#cccc99"></td><td title="#ccff99" style="background-color:#ccff99"></td><td title="#ff0099" style="background-color:#ff0099"></td><td title="#ff3399" style="background-color:#ff3399"></td><td title="#ff6699" style="background-color:#ff6699"></td><td title="#ff9999" style="background-color:#ff9999"></td><td title="#ffcc99" style="background-color:#ffcc99"></td><td title="#ffff99" style="background-color:#ffff99"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#00ffff" style="background-color:#00ffff"></td><td title="#000000" style="background-color:#000000"></td><td title="#9900cc" style="background-color:#9900cc"></td><td title="#9933cc" style="background-color:#9933cc"></td><td title="#9966cc" style="background-color:#9966cc"></td><td title="#9999cc" style="background-color:#9999cc"></td><td title="#99cccc" style="background-color:#99cccc"></td><td title="#99ffcc" style="background-color:#99ffcc"></td><td title="#cc00cc" style="background-color:#cc00cc"></td><td title="#cc33cc" style="background-color:#cc33cc"></td><td title="#cc66cc" style="background-color:#cc66cc"></td><td title="#cc99cc" style="background-color:#cc99cc"></td><td title="#cccccc" style="background-color:#cccccc"></td><td title="#ccffcc" style="background-color:#ccffcc"></td><td title="#ff00cc" style="background-color:#ff00cc"></td><td title="#ff33cc" style="background-color:#ff33cc"></td><td title="#ff66cc" style="background-color:#ff66cc"></td><td title="#ff99cc" style="background-color:#ff99cc"></td><td title="#ffcccc" style="background-color:#ffcccc"></td><td title="#ffffcc" style="background-color:#ffffcc"></td></tr><tr><td title="#000000" style="background-color:#000000"></td><td title="#ff00ff" style="background-color:#ff00ff"></td><td title="#000000" style="background-color:#000000"></td><td title="#9900ff" style="background-color:#9900ff"></td><td title="#9933ff" style="background-color:#9933ff"></td><td title="#9966ff" style="background-color:#9966ff"></td><td title="#9999ff" style="background-color:#9999ff"></td><td title="#99ccff" style="background-color:#99ccff"></td><td title="#99ffff" style="background-color:#99ffff"></td><td title="#cc00ff" style="background-color:#cc00ff"></td><td title="#cc33ff" style="background-color:#cc33ff"></td><td title="#cc66ff" style="background-color:#cc66ff"></td><td title="#cc99ff" style="background-color:#cc99ff"></td><td title="#ccccff" style="background-color:#ccccff"></td><td title="#ccffff" style="background-color:#ccffff"></td><td title="#ff00ff" style="background-color:#ff00ff"></td><td title="#ff33ff" style="background-color:#ff33ff"></td><td title="#ff66ff" style="background-color:#ff66ff"></td><td title="#ff99ff" style="background-color:#ff99ff"></td><td title="#ffccff" style="background-color:#ffccff"></td><td title="#ffffff" style="background-color:#ffffff"></td></tr></tbody></table></div>
	</div>
  </body>
	<script src="./js/vue.min.js"></script>
	<script>
		/**
		 * 预定义部分全局的变量
		 */
		var global = {
			"temp":false ,
		} 
		var bgImg = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAAH0CAYAAACHEBA3AAAE3UlEQVR42u3UMREAAAgDsRqoN/yrQQdchhj44dN2AC6ICIBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFGJYIgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgUYlgiAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBRiWEIBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhAYYlAmBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBhiUCYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQGGJQJgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhAYYlBGBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBhgVgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWIBhARgWgGEBhgVgWACGBRgWgGEBhgVgWACGBRgWgGEBGBZgWACGBWBYgGEBGBaAYQGGBWBYAIYFGBaAYQEYFmBYAIYFYFiAYQEYFoBhAYYFYFgAhgUYFoBhAYYFYFgAhgUYFoBhARgWYFgAhgVgWMBvC9p8boFKPUhmAAAAAElFTkSuQmCC" ;
		//bgImg = "https://t12.baidu.com/it/u=2897648120,2717953286&fm=76" ;
		//后台渲染，进行组件注册
		var array = {"CONTENT":[],"VUELOGO":[],"VUECLOCK":[],"BAR":[],"VUEPMD":[]} ; //组件的详细信息
		var init = {} ; //组件初始状态(主要控制组件是否显示)
		<c:forEach items="${components}" var="item">
			//注册组件
			Vue.component("${item.name}" , ${item.code}) ;
			//将后台传过来的组件，和组件位置数据进行整合
			<c:forEach items="${list}" var="i">
				{
					var te = ${item.positions} ;
					if(te[0].name == ${i.id}){
						var com = {} ;
						com.id = ${item.id} ;
						com.name = "${item.name}" ;
						com.img = "${item.img}" ;
						com.width = "${item.width}" ;
						com.height = "${item.height}" ;
						com.msg = "${item.msg}" ;
						com.type = "${i.type}" ;
						com.positions = ${item.positions} ;
						array["${i.type}"].push(com) ;
					}
					if(typeof(init["${i.id}"]) == "undefined"){
						init["${i.id}"] = {} ;
					}
					for(var i=0 ; i<te.length ; i++){
						if(te[i].name == ${i.id}){
							init["${i.id}"]["${item.id}"] = false ;
							init["${i.id}"]["${item.id}"+"woos"] = "${item.name}" ;
						}
					}
				}
			</c:forEach>
			//console.log(init) ;
		</c:forEach>
		//使用右键菜单插件
		layui.config({base: './js/mouseRightMenu/'})
		layui.use(['mouseRightMenu','layer','jquery'],function(){
			global.mouseRightMenu = layui.mouseRightMenu,global.layer = layui.layer;
				
		})
		console.log(init) ;
		var vue = new Vue({
			el:"#app",
			data:function () {
			    return {
						left:180,
						right:180,
						flag:false , //表示鼠标是否点中拖动栏
						item:0 ,
						file:"" , //选择的文件
						text:"" , //文字编辑
						size:"" ,
						color:"" ,
						temp:"" ,
						fields:{
							0:true, //背景设置
							1:false , //文字编辑
							2:false , //图片选择
							3:false ,  //内容组件中图,apk选择
							4:false , //导航栏属性编辑
						} , //属性编辑器
						apks:[
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} ,
							{name:"腾讯视频" , packageName:"com.pack.tencent" , image:"./img/image.png" , url:""} 
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
									"content":false , //是否设置内容组件
									"type":"" , // 导航栏位置信息
									data:[]
								} ,  //内容组件与导航栏合并
								"VUEPMD":{
									"id":undefined,
									title:"" ,
									size:"13" ,
									color:"black"
								} ,
								"VUECLOCK":{
									"id":undefined 
								}   
							} ,		//已在面板上设置的组件
							showControl:init , //控制各个组件是否显示		
						} ,
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
			  		text:function(n , o){
			  			if(this.editeEl.type == "VUEPMD"){
			  				this.TVscreenInfo.panel.VUEPMD.title = n ;
			  			}
			  		} ,
			  		size:function(n , o){
			  			if(this.editeEl.type == "VUEPMD"){
			  				this.TVscreenInfo.panel.VUEPMD.size = n ;
			  			}
			  		} ,
			  		color:function(n , o){
			  			if(this.editeEl.type == "VUEPMD"){
			  				this.TVscreenInfo.panel.VUEPMD.color = n ;
			  			}
			  		} ,
			  		"TVscreenInfo.panel.CONTENT.id": function(n , o) {
			  			//当设置内容组件
			  			if((o == undefined || typeof(o) == "undefined") && (n != undefined || typeof(n) != "undefined")){
			  				
			  			}
			  		},
			  		"TVscreenInfo.panel.BAR.id":function(n , o){
			  			//当设置导航栏组件时
			  			if((o == undefined || typeof(o) == "undefined") && (n != undefined || typeof(n) != "undefined")){
			  				alert() ;
			  			}
			  		} ,
			  		"TVscreenInfo.panel.MAIN.item":function(n , o){
			  			for(var i in this.TVscreenInfo.showControl[5]){
			  				if(i*1){
			  					this.TVscreenInfo.showControl[5][i] = false ;
			  				}
			  			}
			  			if(this.TVscreenInfo.panel.MAIN.data[n].data == undefined || typeof(this.TVscreenInfo.panel.MAIN.data[n].data) == "undefined" || this.TVscreenInfo.panel.MAIN.data[n].data.length == 0){
			  				this.TVscreenInfo.panel.MAIN.content = false ;
			  				return ;
			  			}else{
			  				this.TVscreenInfo.panel.MAIN.content = true ;
			  			}
			  			this.TVscreenInfo.showControl[5][this.TVscreenInfo.panel.MAIN.data[n].data.id] = true ;
			  		} ,
			  		"editeEl.type":function(n , o){
			  			//将当前所点击的组件属性栏打开
			  			var m = {"VUEPMD":1} ;
						for(var i in this.fields){
							if(i*1 == 0){
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
							}
						}
			  		} ,
    				deep: true
			  } ,
			  methods:{
					item_click_down:function(e , item){
						if(!this.flag){
							this.item = item ;
							this.flag = true ;
						}
					} ,
					removeBar:function(index){
						if(this.TVscreenInfo.panel.MAIN.data != undefined && typeof(this.TVscreenInfo.panel.MAIN.data) != "undefined"){
							if(this.TVscreenInfo.panel.MAIN.data.length < 2){
								layer.msg('导航栏菜单个数不能低于1个', {icon: 5});
								return ;
							}
							this.TVscreenInfo.panel.MAIN.data.splice(index , 1);
						}
					} ,
					addBarItem:function(){
						if(this.TVscreenInfo.panel.MAIN.data != undefined && typeof(this.TVscreenInfo.panel.MAIN.data) != "undefined"){
							var data = {} ;
							data.id = this.TVscreenInfo.panel.MAIN.data.length ;
							data.name = "" ;
							data.img = "" ;
							data.selectedImg = "" ;
							data.selectedColor = "" ;
							data.data = [] ;
							this.TVscreenInfo.panel.MAIN.data.push(data);
						}
					} ,
					addImg:function(msg){
						var file = document.createElement("input") ;
						file.type = "file" 
						var self = this ;
						file.onchange = function(e){
							var f = "" ;
							if(e.path == undefined || typeof(e.path)){
								f = e.target.files[0] ;
							}else{
								f = e.path[0].files[0] ;
							}
							if(undefined == f) {
								return;
							}
							r = new FileReader();
							r.readAsDataURL(f);
							var base64 = "";
							r.onload = function(e) {
								base64 = e.target.result;
								if(msg == "content"){
									if(self.TVscreenInfo.panel.MAIN.bar){
				 						self.TVscreenInfo.panel.MAIN.data[self.TVscreenInfo.panel.MAIN.item].data.info[self.editeEl["content_item"]].imgs.push(base64) ;
				 					}else{
				 						self.TVscreenInfo.panel.MAIN.data[0].data.info[self.editeEl["content_item"]].imgs.push(base64) ;
				 					}
								}else if(msg == "bar_add"){
									if(self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img == "" || self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img == undefined || typeof(self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img) == "undefined"){
										self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img = base64 ;
									}else{
										self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].selectedImg = base64 ;
									}
								}else if(msg == "bar_change"){
									self.TVscreenInfo.panel.MAIN.data[self.editeEl["bar_item"]].img = base64 ;
								}
							}
						}
						file.click() ; 
					} ,
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
			 					var file = document.createElement("input") ;
								file.type = "file" 
								file.onchange = function(e){
									var f = "" ;
									if(e.path == undefined || typeof(e.path)){
										f = e.target.files[0] ;
									}else{
										f = e.path[0].files[0] ;
									}
									if(undefined == f) {
										return;
									}
									r = new FileReader();
									r.readAsDataURL(f);
									var base64 = "";
									r.onload = function(e) {
										base64 = e.target.result;
										if(self.TVscreenInfo.panel.MAIN.bar){
					 						self.TVscreenInfo.panel.MAIN.data[self.TVscreenInfo.panel.MAIN.item].data.info[self.editeEl["content_item"]].imgs.splice(index , 1 , base64) ;
					 					}else{
					 						self.TVscreenInfo.panel.MAIN.data[0].data.info[self.editeEl["content_item"]].imgs.splice(index , 1 , base64) ;
					 					}
									}
								}
								file.click() ; 
			 				}
			 			})
						return false;
					} ,
					clear:function(){
						for(var i in this.editeEl){
							this.editeEl[i] = undefined ;
						}
					} ,
					bg_change:function(){
						var file = document.createElement("input") ;
						file.type = "file" 
						var self = this;
						file.onchange = function(e){
							var f = "" ;
							if(e.path == undefined || typeof(e.path)){
								f = e.target.files[0] ;
							}else{
								f = e.path[0].files[0] ;
							}
							if(undefined == f) {
								return;
							}
							r = new FileReader();
							r.readAsDataURL(f);
							var base64 = "";
							r.onload = function(e) {
								base64 = e.target.result;
								self.TVscreenInfo.panel.BG.flag = true ;
								self.TVscreenInfo.panel.BG.img = base64 ;
							}
						}
						file.click() ;
					} ,
					colorSelet:function(e){
						var panel = document.getElementById("cxcolor") ;
						if(panel.style.display == "none"){
							panel.style.display = "block" ;
						}else{
							panel.style.display = "none" ;
						}
						panel.style.top = (e.clientY+18)+'px' ;
						panel.style.right = (document.body.clientWidth - e.clientX - 20)+'px' ;
					} ,
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
					file_select:function(){
						var file = document.createElement("input") ;
						file.type = "file" 
						var self = this;
						file.onchange = function(e){
							var f = "" ;
							if(e.path == undefined || typeof(e.path)){
								f = e.target.files[0] ;
							}else{
								f = e.path[0].files[0] ;
							}
							if(undefined == f) {
								return;
							}
							r = new FileReader();
							r.readAsDataURL(f);
							var base64 = "";
							r.onload = function(e) {
								base64 = e.target.result;
								self.file = base64 ;
							}
						}
						file.click() ;
					} ,
					item_click_up:function(){
						this.flag = false ;
						this.cursor = "default" ;
					} ,
					panelClick:function(e){
						
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
						var top = e.pageY - 1 ;
						this.cursorOn(top , left) ;
						this.current = {} ;
						var list = document.querySelectorAll(".vue-panel") ;
						for(var i=0 ; i<list.length ; i++){
							list[i].style.border = "none" ;
							list[i].style.background = "none" ;
						}
					},
					selectCover:function(e){ //此方法求出标签所覆盖的所有的标签
						
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
											this.TVscreenInfo.panel.MAIN.content = true ;
											this.TVscreenInfo.panel.MAIN.bar = false ;
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
						self.TVscreenInfo.width = document.querySelector(".main_TV_panel").offsetWidth ;
						self.TVscreenInfo.height = document.querySelector(".main_TV_panel").offsetHeight ;
					}
				},
				updated:function(){
					this.TVscreenInfo.width = document.querySelector(".main_TV_panel").offsetWidth ;
					this.TVscreenInfo.height = document.querySelector(".main_TV_panel").offsetHeight ;
				} ,
				beforeCreate:function(){
					vue = this ;
				}
			});
			window.onresize = function(){
				vue.TVscreenInfo.width = document.querySelector(".main_TV_panel").offsetWidth ;
				vue.TVscreenInfo.height = document.querySelector(".main_TV_panel").offsetHeight ;
			}
	</script>
</html>
