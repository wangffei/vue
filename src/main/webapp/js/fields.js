//背景属性编辑
Vue.component("v-fields0" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">背景</div><div style="width:100%;height:120px;overflow:hidden;"><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">背景：<div @click="bg_change()" class="layui-btn layui-btn-xs">选择图片</div></div><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">颜色：<el-color-picker size="small" v-model="color" show-alpha></el-color-picker></div></div></div>',
	name:"v-fields0" ,
	data:function(){
		return{
			color:""
		}
	} ,
	props:{
		data:Object ,
		now:Object ,
		pcolor:String
	} ,
	watch:{
		color:function(n , o){
			if(this.now["type"] == "MAIN" && this.now["content_item"] != undefined && typeof(this.now["content_item"]) != "undefined"){
				this.data.border = n ;
			}else if(this.now["type"] == "VUEPMD"){
				this.data.VUEPMD.color = n ;
			}else{
				this.data.color = n ;
			}
		}
	} ,
	created(){
		
	} ,
	methods:{
		bg_change:function(){
			this.$emit("bg_change") ;
		} 
	} 
})
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields0 v-if="fields[0]" :data="TVscreenInfo.panel" :now="editeEl" @bg_change="bg_change" ></v-fields0>' ;

//边角设置
Vue.component("v-fields8" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">边角</div><div style="width:100%;overflow:hidden;"><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">边角：<div @change="border_change()"><select v-model="type_model"><option v-for="border in borders" :value="border.value">{{border.name}}</option></select></div></div><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">颜色：<div @change="color_change()"><select v-model="color_model"><option v-for="color in colors" :value="color.value">{{color.name}}</option></select></div></div></div></div>',
	name:"v-fields8" ,
	data:function(){
		return{
			colors:[
				{name:"无边框" , value:"none"} ,
				{name:"白色" , value:"white"} ,
				{name:"绿色" , value:"green"} ,
				{name:"蓝色" , value:"blue"} ,
				{name:"黄色" , value:"yellow"}
			] ,
			borders:[
				{name:"直角" , value:"rect"} ,
				{name:"圆角" , value:"round"}
			] ,
			type_model:"rect" ,
			color_model:"none"
		}
	} ,
	props:{
		data:Object
	} ,
	created(){ 
		this.type_model = this.data.BORDER.type
		this.color_model = this.data.BORDER.color 
	} ,
	methods:{
		color_change:function(){
			this.data.BORDER.color = this.color_model
		} ,
		border_change:function(){
			this.data.BORDER.type = this.type_model
		}
	} 
})
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields8 v-if="fields[7]" :data="TVscreenInfo.panel" ></v-fields8>'

//文字属性编辑
Vue.component("v-fields1" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">文字</div><div style="width:100%;height:auto;overflow:hidden;"><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">大小：<select name="city" lay-verify="" v-model="size" style="width:60px;height:25px;"><option value="l">大</option> <option value="m">中</option> <option value="s">小</option></select></div><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">速度：<select name="city" lay-verify="" v-model="speed" style="width:60px;height:25px;"><option value="l">快</option> <option value="m">中</option> <option value="s">慢</option></select></div><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">背景色：<el-color-picker size="small" v-model="color" show-alpha></el-color-picker></div><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">方向：<select name="city" lay-verify="" v-model="dirction" style="width:60px;height:25px;"><option value="l">向左</option> <option value="r">向右</option></select>  </div><div style="display:flex;width:100%;padding-left:5px;margin-top:20px;">内容：<textarea v-model="text" name="" required lay-verify="required" placeholder="请输入" class="layui-textarea" style="width:60%;"></textarea></div></div></div>',
	name:"v-fields1" ,
	data:function(){
		return{
			size:"s" ,
			dirction:"r" ,
			text:"" ,
			color:"none" ,
			speed:"s"
		}
	} ,
	props:{
		data:Object ,
		now:Object 
	} ,
	created(){
		this.size = this.data.VUEPMD.size
		this.text = this.data.VUEPMD.title
		this.dirction = this.data.VUEPMD.dirction
		this.speed = this.data.VUEPMD.speed
		this.color = this.data.VUEPMD.bkcolor
	} ,
	methods:{
		
	} ,
	watch:{
		dirction:function(n , o){
			if(this.now["type"] == "VUEPMD"){
  				this.data.VUEPMD.dirction = n ;
  			}
		} ,
		size:function(n , o){
			if(this.now.type == "VUEPMD"){
  				this.data.VUEPMD.size = n ;
  			}
		} ,
		text:function(n , o){
  			if(this.now.type == "VUEPMD"){
  				this.data.VUEPMD.title = n ;
  			}
		} ,
		speed:function(n , o){
			if(this.now.type == "VUEPMD"){
  				this.data.VUEPMD.speed = n ;
  			}
		} ,
		color:function(n , o){
			if(this.now.type == "VUEPMD"){
  				this.data.VUEPMD.bkcolor = n ;
  			}
		}
	}
})
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields1 v-if="fields[1]" :data="TVscreenInfo.panel" :now="editeEl"></v-fields1>' ;
//2

//选择图片或者视频的组件
Vue.component("v-fields6" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">类型</div><div style="width:100%;height:50px;"><select style="width:60%;height:30px;margin:10px auto;" class="layui-input" v-model="data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now[\'content_item\']].type" name="type" lay-verify="required"><option value="img">图片</option><option value="video">视频</option></select></div></div>',
	name:"v-fields6" ,
	data:function(){
		return{
			
		}
	} ,
	props:{
		data:Object ,
		now:Object
	} 
}) ;
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields6 v-if="fields[6]" :data="TVscreenInfo.panel" :now="editeEl"></v-fields6>' ;

//编辑图片相关的组件
Vue.component("v-fields2" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">图片</div><div style="width:100%;height:50px;overflow:hidden;"><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;">文件：<div @click="file_select()" class="layui-btn layui-btn-xs">选择图片</div></div></div></div>',
	name:"v-fields2" ,
	data:function(){
		return{
			
		}
	} ,
	props:{
		fun:Object ,
		file:String
	} ,
	created(){
		
	} ,
	methods:{
		file_select:function(){
			var self = this ;
			this.fun = function(base64){
				if(!base64.startsWith("data:image/")){
					layer.alert("只支持图片") ;
					return ;
				}
				this.file = base64 ;
			}
			$("#file").click() ;
		}
	} 
})

Vue.component("v-fields3" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">图片</div><div style="width:100%;overflow:hidden;"><div style="display:flex;width:100%;padding-left:5px;padding:8px 5px;border-bottom:0.3px solid #dbdbdb;">应用：<div style="width:60px;height:30px;">{{data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now["content_item"]].apkName.length >= 4 ? data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now["content_item"]].apkName.substr(0 , 4) : data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now["content_item"]].apkName}}</div><div class="layui-btn layui-btn-xs layui-btn-normal" @click="selectApk()">选择apk</div></div><div style="display:flex;width:100%;padding-left:5px;padding:8px 5px;border-bottom:0.3px solid #dbdbdb;"><div style="width:60px;height:30px;"><el-checkbox style="margin:3px 20px;color:white;" v-model="def" >设为默认</el-checkbox></div></div><div style="display:flex;margin-top:5px;flex-wrap:wrap;"><div class="content_img" @contextmenu="leftmenu(index)" @click="leftmenu(index)" style="width:40px;height:40px;margin:5px 0px 0px 5px;" v-for="(img , index) in ((data.MAIN.bar ? data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now.content_item] : data.MAIN.data[0].data.info[now.content_item]) == undefined || typeof((data.MAIN.bar ? data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now.content_item] : data.MAIN.data[0].data.info[now.content_item])) == \'undefined\') ? [] : (data.MAIN.bar ? data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now.content_item].imgs : data.MAIN.data[0].data.info[now.content_item].imgs)"><img :src="img" style="width:40px;height:40px;cursor:pointer;display:block;" title="修改"></div></div><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;margin-left:5px;"><button @click="addImg" type="button" class="layui-btn layui-btn-xs layui-btn-primary" style="width:90%;">添加图片</button><button @click="edite_sub_page" type="button" class="layui-btn layui-btn-xs layui-btn-primary" v-if="data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now[\'content_item\']].packageName == \'com.woos.ppt\'" style="width:90%;">编辑二级页面</button></div></div></div>',
	name:"v-fields3" ,
	data:function(){
		return{
			def:false
		}
	} ,
	props:{
		data:Object ,
		now:Object ,
		apks:[] ,
		apkurl:String
	} ,
	created(){
		if(this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].def == this.now["content_item"]){
			this.def = true ;
		}
	} ,
	watch:{
		def:function(n , o){
			if(n && (this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].data.info[this.now["content_item"]].apkName == undefined || this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].data.info[this.now["content_item"]].apkName == "")){
				layui.layer.msg("请先选择apk")
				this.def = false
				return
			}else if(n){
				this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].def = this.now["content_item"] ;
				this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].defaultApk = this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].data.info[this.now["content_item"]].packageName ;
			}
		}
	} ,
	methods:{
		edite_sub_page:function(){
			layui.use('layer', function(){
			  var layer = layui.layer;
			  
			  layer.open({
				  type: 2,
				  shade: false,
				  area: [vue.$data.TVscreenInfo.width , vue.$data.TVscreenInfo.height],
				  maxmin: true,
				  content: './vuePage/subPages.jsp',
				  zIndex: layer.zIndex, //重点1
				  success: function(layero){
				    layer.setTop(layero); //重点2
				  }
				});
			}); 
		} ,
		selectApk:function(){
			var html = '<div style="width:100%;height:100%;align-items:center;justify-content:center;display:flex;color:white;"><div style="width:30px;height:30px;"><img style="width:30px;height:30px;" src="./img/uploading.gif"></div></div>' ;
			var panel = layer.open({
			  type: 1, 
			  title:"应用商城" ,
			  area:['800px' , '400px'] ,
			  content: html
			});
			if(this.apks.length == 0){
				var self = this ;
				if(this.apks.length == 0){
					$.ajax({
						url:self.apkurl ,
						type:"GET" ,
						success:function(res){
							if(res.code != 200){
								layer.msg("【faild】"+res.msg, {icon: 5});
								layer.close(panel) ;
							}else{
								self.apks.push.apply(self.apks, res.data);
								layer.close(panel) ;
								self.apkShow(self.apks) ;
							}
						} , 
						error:function(){
							layer.msg("获取数据失败", {icon: 5});
							layer.close(panel) ;
						}
					}) ;
				}
			}else{
				layer.close(panel) ;
				this.apkShow(this.apks) ;
			}
			this.$forceUpdate()
		} ,
		apkShow:function(arr){
			var html = '' ;
			for(var i=0 ; i<arr.length ; i++){
				html+="<div style='width:71px;height:80px;display:flex;flex-direction:column;text-align:center;cursor:pointer;' onclick='apkSelect("+i+")' onmouseout ='apkOut(this)' onmouseover='apkHover(this)'><img style='width:50px;height:50px;margin-left:10px;' src='"+arr[i].image+"'>"+(arr[i].apkName.length >= 4 ? arr[i].apkName.substr(0 , 4) : arr[i].apkName)+"</div>" ;
			}
			html = "<div style='width:100%;height:100%;display:flex;flex-wrap:wrap;'>"+html+"</div>" ;
			apkPanel = layer.open({
			  type: 1, 
			  title:"应用商城" ,
			  area:['800px' , '400px'] ,
			  content: html
			});
		} ,
		//鼠标点击事件
		leftmenu:function(index){
			this.$emit("leftmenu" , index)
		} ,
		addImg:function(){
			this.$emit("add_img" , "content")
		}
	} 
})
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields3 v-if="fields[3] && TVscreenInfo.panel.MAIN.data[(TVscreenInfo.panel.MAIN.item == undefined ? 0 : TVscreenInfo.panel.MAIN.item)].data.info[editeEl[\'content_item\']].type == \'img\'" :fun="fun" :apks="apks" :data="TVscreenInfo.panel" @leftmenu="leftmenu" @add_img="addImg" :now="editeEl" :apkurl="global.apks"></v-fields3>' ;


Vue.component("v-fields4" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;display:flex;color:white;"><div style="width:70%;">菜单</div><div class="layui-btn layui-btn-xs layui-btn-primary" style="width:50px;" @click="addBarItem()">添加</div></div><div style="width:100%;overflow:hidden;"><div v-for="(item,index) in data.MAIN.data" style="display:flex;width:90%;padding-left:5px;flex-wrap:wrap;font-size:12px;line-height:25px;height:25px;color:gray;border:1px solid #91dbff;box-shadow:1px 1px 115px #e3e3e3;margin-top:3px;position:relative;" ><input v-model="item.name" style="width:70%;height:100%;border:0px;"><img src="./img/close.png" style="display:block;float:right;width:20px;height:20px;position:absolute;right:0px;cursor:pointer;" @click="removeBar(index)"></div></div></div>',
	name:"v-fields4" ,
	data:function(){
		return{
			
		}
	} ,
	props:{
		data:Object
	} ,
	created(){
		
	} ,
	methods:{
		addBarItem:function(){
			if(this.data.MAIN.data != undefined && typeof(this.data.MAIN.data) != "undefined"){
				var data = {} ;
				data.id = this.data.MAIN.data.length ;
				data.name = "" ;
				data.img = "" ;
				data.selectedImg = "" ;
				data.selectedColor = "" ;
				data.data = [] ;
				this.data.MAIN.data.push(data);
			}
		} ,
		removeBar:function(index){
			if(this.data.MAIN.data != undefined && typeof(this.data.MAIN.data) != "undefined"){
				if(this.data.MAIN.data.length < 4){
					layer.msg('导航栏菜单个数不能低于3个', {icon: 5});
					return ;
				}
				this.data.MAIN.data.splice(index , 1);
			}
		} 
	} 
})
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields4  v-if="fields[4]" :data="TVscreenInfo.panel"></v-fields4>'

Vue.component("v-fields5" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">图标</div><div style="width:100%;overflow:hidden;"><div v-if="data.MAIN.type == \'bar_icon\'" style="display:flex;width:100%;padding-left:5px;flex-wrap:wrap;margin:5px;"><img style="width:40px;height:40px;" @click="addImg" v-if="data.MAIN.data[data.MAIN.item].img != undefined && typeof(data.MAIN.data[data.MAIN.item].img) != \'undefined\' && data.MAIN.data[data.MAIN.item].img != \'\'" :src="data.MAIN.data[data.MAIN.item].img"><div style="width:40px;height:40px;line-height:40px;text-align:center;font-size:12px;color:white;background:gray;" v-if="data.MAIN.data[data.MAIN.item].img == undefined || typeof(data.MAIN.data[data.MAIN.item].img) == \'undefined\' || data.MAIN.data[data.MAIN.item].img == \'\'"  @click="addImg">添加</div></div></div></div>',
	name:"v-fields5" ,
	data:function(){
		return{
			
		}
	} ,
	props:{
		data:Object
	} ,
	created(){
		
	} ,
	methods:{
		addImg:function(){
			this.$emit("add_img" , "bar_change")
		}
	} 
})
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields5 v-if="fields[4] && TVscreenInfo.panel.MAIN.type == \'bar_icon\'" :data="TVscreenInfo.panel"  @add_img="addImg"></v-fields5>'

Vue.component("v-fields7" , {
	template:'<div><div style="width:100%;height:25px;background:#5f5f5f;line-height:25px;padding-left:10px;color:white;">视频</div><div style="width:100%;overflow:hidden;"><div style="display:flex;width:100%;padding-left:5px;padding:8px 5px;border-bottom:0.3px solid #dbdbdb;">应用：<div style="width:60px;height:30px;">{{data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now["content_item"]].apkName.length >= 4 ? data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now["content_item"]].apkName.substr(0 , 4) : data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now["content_item"]].apkName}}</div><div class="layui-btn layui-btn-xs layui-btn-normal" @click="selectApk()">选择apk</div></div><div style="display:flex;width:100%;padding-left:5px;padding:8px 5px;border-bottom:0.3px solid #dbdbdb;"><div style="width:60px;height:30px;"><el-checkbox style="margin:3px 20px;color:white;" v-model="def" >设为默认</el-checkbox></div></div><div style="width:80%;margin:0px aoto;height:30px;line-height:30px;text-align:center;font-size:12px;color:gray;">{{name}}</div><div style="display:flex;width:100%;padding-left:5px;height:30px;margin-top:20px;margin-left:5px;"><button @click="$(\'#video\').click()" type="button" class="layui-btn layui-btn-xs layui-btn-primary" style="width:90%;">选择视频</button><button @click="edite_sub_page" type="button" class="layui-btn layui-btn-xs layui-btn-primary" v-if="data.MAIN.data[(data.MAIN.item == undefined ? 0 : data.MAIN.item)].data.info[now[\'content_item\']].packageName == \'com.woos.ppt\'" style="width:90%;">编辑二级页面</button></div></div></div>',
	name:"v-fields7" ,
	data:function(){
		return{
			def:false
		}
	} ,
	props:{
		data:Object ,
		now:Object , 
		apks:[] ,
		apkurl:String
	} ,
	created(){
		if(this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].def == this.now["content_item"]){
			this.def = true ;
		}
	} ,
	watch:{
		def:function(n , o){
			if(n && (this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].data.info[this.now["content_item"]].apkName == undefined || this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].data.info[this.now["content_item"]].apkName == "")){
				layui.layer.msg("请先选择apk")
				this.def = false
				return
			}else if(n){
				this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].def = this.now["content_item"] ;
				this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].defaultApk = this.data.MAIN.data[(this.data.MAIN.item == undefined ? 0 : this.data.MAIN.item)].data.info[this.now["content_item"]].packageName ;
			}
		}
	} ,
	methods:{
		edite_sub_page:function(){
			layui.use('layer', function(){
			  var layer = layui.layer; 
			  
			  layer.open({
				  type: 2,
				  shade: false,
				  area: [vue.$data.TVscreenInfo.width , vue.$data.TVscreenInfo.height],
				  maxmin: true,
				  content: './vuePage/subPages.jsp',
				  zIndex: layer.zIndex, //重点1
				  success: function(layero){
				    layer.setTop(layero); //重点2
				  }
				});
			}); 
		} ,
		selectApk:function(){
			var html = '<div style="width:100%;height:100%;align-items:center;justify-content:center;display:flex;"><div style="width:30px;height:30px;"><img style="width:30px;height:30px;" src="./img/uploading.gif"></div></div>' ;
			var panel = layer.open({
			  type: 1, 
			  title:"应用商城" ,
			  area:['800px' , '400px'] ,
			  content: html
			});
			if(this.apks.length == 0){
				var self = this ;
				if(this.apks.length == 0){
					$.ajax({
						url:self.apkurl ,
						type:"GET" ,
						success:function(res){
							if(res.code != 200){
								layer.msg("【faild】"+res.msg, {icon: 5});
								layer.close(panel) ;
							}else{
								self.apks.push.apply(self.apks, res.data);
								layer.close(panel) ;
								self.apkShow(self.apks) ;
							}
						} , 
						error:function(){
							layer.msg("获取数据失败", {icon: 5});
							layer.close(panel) ;
						}
					}) ;
				}
			}else{
				layer.close(panel) ;
				this.apkShow(this.apks) ;
			}
			this.$forceUpdate()
		} ,
		apkShow:function(arr){
			var html = '' ;
			for(var i=0 ; i<arr.length ; i++){
				html+="<div style='width:71px;height:80px;display:flex;flex-direction:column;text-align:center;cursor:pointer;' onclick='apkSelect("+i+")' onmouseout ='apkOut(this)' onmouseover='apkHover(this)'><img style='width:50px;height:50px;margin-left:10px;' src='"+arr[i].image+"'>"+(arr[i].apkName.length >= 4 ? arr[i].apkName.substr(0 , 4) : arr[i].apkName)+"</div>" ;
			}
			html = "<div style='width:100%;height:100%;display:flex;flex-wrap:wrap;'>"+html+"</div>" ;
			apkPanel = layer.open({
			  type: 1, 
			  title:"应用商城" ,
			  area:['800px' , '400px'] ,
			  content: html
			});
		} ,
	} 
})
document.querySelector(".vue-size").innerHTML = document.querySelector(".vue-size").innerHTML + '<v-fields7 v-if="fields[5] && TVscreenInfo.panel.MAIN.data[(TVscreenInfo.panel.MAIN.item == undefined ? 0 : TVscreenInfo.panel.MAIN.item)].data.info[editeEl[\'content_item\']].type == \'video\'" :data="TVscreenInfo.panel"  :now="editeEl" :apks="apks" :apkurl="global.apks"></v-fields7>'