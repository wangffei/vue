<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <base href="<%=basePath%>">

    <title>二级页面编辑器</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta charset="utf-8">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">

    <link rel="stylesheet" type="text/css" href="/js/layui/css/layui.css">

    <script type="text/javascript" src="./js/jquery-1.11.0.min.js"></script>
    <script src="./js/layui/layui.js"></script>
    <script src="./js/vue.min.js"></script>
    <script src="./js/spark-md5.min.js"></script>
    <style>
        * {
            margin: 0px;
            padding: 0px;
        }

        html, body {
            width: 100%;
            height: 100%;
        }

        #app {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        #top {
            width: 100%;
            height: 50px;
            background: #323232;
            font-size: 20px;
            line-height: 50px;
            color: white;
        }

        #main {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: row;
        }

        #main .left {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        #main .right {
            width: 230px;
            height: 100%;

        }

        #main .left .l-top {
            width: 100%;
            height: 50px;
            border-bottom: 1px solid black;
        }

        #main .left .l-top .icon {
            width: 80px;
            height: auto;
            border-right: 1px solid black;
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
            overflow: hidden;
        }

        #panel {
            width: 100%;
            height: 100%;
        }

        .panel-main {
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

        .panel-carousel-item-bar {
            width: 100%;
            height: 50px;
            position: fixed;
            bottom: 0px;
            background: url(./img/empty.png);
            display: block;
        }

        .panel-carousel-item-bar .item {
            width: 90px;
            height: 40px;
            background: gray;
            border-radius: 10px;
            margin: 5px 15px;
            cursor: pointer;
            line-height: 40px;
            text-align: center;
            white: black;
            overflow: hidden;
            float: left;
        }

        .panel-carousel-item-bar .item:hover {
            background: red;
            color: white;
        }

        .panel .panel-main .panel-show {
            width: 100%;
            height: 100%;
        }

        .panel-show .panel-addImg {
            width: 85%;
            height: 75%;
            margin: 0px auto;
            border: 2px dotted gray;
            text-align: center;
        }
    </style>
</head>

<body>
<div id="app">
    <div id="top">二级页面编辑器
        <div style="float: right;margin-right:30px;">
            <button class="layui-btn" @click="del()">删除</button>
            <button class="layui-btn" @click="save()">保存</button>
        </div>
    </div>
    <div id="main">
        <div class="left">
            <div id="panel">
                <div class="panel-main" v-if="Carousel">
                    <div v-if="panel.data.length == 0" class="panel-show">
                        <div @click="addImg()" class="panel-addImg"
                             :style="{marginTop:((height - 100) - (height - 100)*0.75) / 2 + 'px',lineHeight:(height - 100)*0.75+'px'}">
                            点击空白区域添加图片
                        </div>
                    </div>
                    <div v-if="panel.data.length != 0" class="panel-show">
                        <div @click="updateImg()" class="panel-addImg"
                             :style="{marginTop:((height - 100) - (height - 100)*0.75) / 2 + 'px',lineHeight:(height - 100)*0.75+'px'}">
                            <img :src="panel.data[imgItem.item]" style="width: 100%;height: 100%"/>
                        </div>
                    </div>
                    <div class="panel-carousel-item-bar">
                        <div @click="select(index)" v-for="(item,index) in panel.data" class="item">
                            <img class="images" style="width:100%;height:100%;" :src="item"/>
                        </div>
                        <div class="item" @click="addImg()">添加</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="right">

        </div>
    </div>
</div>
<input type="file" id="file" onchange="file()" style="display:none;"/>
</body>

<script>
	var item = parent.vue.$data.TVscreenInfo.panel.MAIN.item == undefined ? 0 : parent.vue.$data.TVscreenInfo.panel.MAIN.item ;
	var index = parent.vue.$data.editeEl['content_item'] ;
	var value = parent.vue.$data.TVscreenInfo.panel.MAIN.data[item].data.info[index].ppt ;
	
	if(value == undefined){
		value = [] ;
	}
	
    var mouseMove = [];
    var mouseDown = [];
    var mouseUp = [];
    var fileFun = [];

    var app = new Vue({
        el: "#app",
        data: {
            Carousel: true,
            width: 0,
            height: 0,
            imgItem: {
                item: 0,
            },
            panel: {
                type: "imgs",
                bg: "",
                data: value
            }
        },
        created: function () {
            var self = this;
            this.width = document.body.clientWidth;
            this.height = document.body.clientHeight;
            mouseMove.push(function (e) {
                /* if (e.pageY > self.height - 50) {
                     $(".panel-carousel-item-bar").css("display", "block");
                 } else {
                     $(".panel-carousel-item-bar").css("display", "none");
                 }*/
            });
        },
        methods: {
            mousedown: function (event) {
                event = event ? event : window.event;
                for (var i in mouseDown) {
                    mouseMove[i](event);
                }
            },
            mousemove: function (event) {
                event = event ? event : window.event;
                for (var i in mouseMove) {
                    mouseMove[i](event);
                }
            },
            mouseup: function (event) {
                event = event ? event : window.event;
                for (var i in mouseUp) {
                    mouseMove[i](event);
                }
            },
            addImg: function () {
                var self = this;
                fileFun.push(function (str) {
                    self.panel.data.push(str);
                    self.imgItem.item = self.panel.data.length - 1;
                });
                $("#file").click();
            },
            updateImg: function () {
                var self = this;
                fileFun.push(function (str) {
                    self.panel.data[self.imgItem.item] = str;
                });
                $("#file").click();
            },
            select: function (index) {
                this.imgItem.item = index;
            },
            del: function () {
                var index = this.imgItem.item;
                this.panel.data.splice(index, 1);
                this.imgItem.item = this.panel.data.length - 1;
                app.$forceUpdate();

            } ,
            save:function(){
				parent.vue.$data.TVscreenInfo.panel.MAIN.data[item].data.info[index].ppt = this.panel.data ;
				layui.use('layer', function(){
				  var layer = layui.layer;
				  
				  layer.msg('保存成功');
				});	
				parent.vue.$data.isChange = true ;
			}
        }
    });

    function file(event) {
        event = event ? event : window.event;
        if (event.target.files[0] == undefined) {
            layer.alert("出错了");
            return;
        }
        var r = new FileReader();
        r.readAsDataURL(event.target.files[0]);
        var base64 = "";
        var size = event.target.files[0].size;
        var currentSize = 0;
        if (!event.target.files[0].type.startsWith("image")) {
            layer.alert("此处只能选择图片");
            return
        }
        r.onload = function (e) {
            base64 = e.target.result;
            currentSize += (e.target.result.substr(e.target.result.indexOf(",") + 1)).length * 0.75;

            // if (currentSize!= size)
            {
                for (var i in fileFun) {
                    if (fileFun[i] != undefined) {
                        fileFun[i](base64);
                        fileFun[i] = undefined;
                    }
                }
                fileFun.splice(0, fileFun.length);
            }
            app.$forceUpdate();
        }
    }

    window.onresize = function () {
        app.$data.width = document.body.clientWidth;
        app.$data.height = document.body.clientHeight;
    }

    $(document).on("dragover", ".images", function (e) {
        return false;
    });

    var currentImage = null;
    var begin = -1;
    var end = -1;
    $(document).on("dragstart", ".images,div", function (e) {
        currentImage = e.target;
    });


    $(document).on("drop", ".images", function (e) {
        e.preventDefault();
        var source = currentImage;
        var desc = e.target;
        if (source.tagName == "IMG" && desc.tagName == "IMG") {
            begin = $(".images").index(source);
            end = $(".images").index(desc);
            var arr = app.panel.data;
            var  t = arr[begin];
            //console.log(begin);
            //console.log(end)
            arr[begin] = arr[end];
            arr[end]  = t;
            app.$forceUpdate();
            app.imgItem.item = end;
            return false;
        }

    })


</script>
</html>
