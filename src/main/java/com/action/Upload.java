package com.action;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.util.HexUtil;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.pojo.FileInfo;
import com.service.DragService;
import com.vo.ApiClass;

/**
 * 文件上传下载
 * @author wangfei
 * 图片上传时间太长的解决方案（进行md5对比，相同的图片不上传）
 */
@Controller
public class Upload {
	
	private String separator = File.separator;
	
	@Autowired
	private DragService service ;
	
//	@RequestMapping("/upload")
//	public String upload(){
//		
//		return null ;
//	}
	
	public ApiClass image(Integer width , Integer height){
		
		return null ;
	}
	
	/**
	 * 界面文件上传
	 * @param language 界面语言
	 * @param code     界面代码
	 * @return		     返回部分不满足分辨率的图片
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping("/pageUpload")
	@ResponseBody
	public ApiClass page(String language , String id , String code) throws NoSuchAlgorithmException{
		ApiClass api = new ApiClass() ;
		Map<String, Object> map = null ;
		//判断语言参数是否为空
		if(language == null || language.equals("")){
			api.setCode(500);
			api.setMsg("语言错误");
			api.setData("");
			return api ;
		}
		if(id != null){
			try{
				Integer.parseInt(id) ;
			}catch(Exception e){
				api.setCode(500);
				api.setMsg("id异常");
				api.setData("");
				return api ;
			}
		}else{
			api.setCode(500);
			api.setMsg("id异常");
			api.setData("");
			return api ;
		}
		//当选择语言为中文的时候
		if(code == null || code.equals("")){
			api.setCode(500);
			api.setMsg("界面数据异常");
			api.setData("");
			return api ;
		}else{
			map = JSONObject.parseObject(code, Map.class) ;
			//将所有图片计算md5并存数据库
			//图片存储路径
			String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()) ;
			String path = System.getProperty("ROOT_PATH")+"screen"+separator+"upload"+separator + date;
			//找出背景图片
			String bgBase64 = (String)((Map)((Map)map.get("panel")).get("BG")).get("img") ;
			if(bgBase64 != null && bgBase64.startsWith("data:image/")){
				if(!new File(path).exists()){
					new File(path).mkdirs() ;
				}
				String suffix = bgBase64.substring(11 , bgBase64.indexOf(";")) ;
				String name = UUID.randomUUID().toString().replaceAll("-", "")+"."+suffix ;
				//将md5图片转换成字节数组
				//byte[] data = Base64.decode(bgBase64.substring(bgBase64.indexOf(",")+1)) ;
				MessageDigest md5Digest = MessageDigest.getInstance("md5");
				//对图片进行md5计算
	            byte[] digest = md5Digest.digest(bgBase64.getBytes());
	            String md5 = HexUtil.encodeHexStr(digest) ;
	            if(!service.isExist(md5)){
	            	FileInfo pictrul = new FileInfo() ;
	            	pictrul.setMd5(md5);
	            	pictrul.setType("img");
	            	pictrul.setUrl("./screen/upload/"+date+"/"+name);
	            	FileInfo p = service.addImg(pictrul) ;
	            	Base64.decodeToFile(bgBase64.substring(bgBase64.indexOf(",")+1), new File(path+separator+name)) ;
	            	((Map)((Map)map.get("panel")).get("BG")).put("img", p.getUrl()) ;
	            }else{
	            	FileInfo p = service.getImg(md5) ;
	            	((Map)((Map)map.get("panel")).get("BG")).put("img", p.getUrl()) ;
	            }
			}
			//1.找出logo中的图片
			String logoBase64 = (String)((Map)((Map)map.get("panel")).get("VUELOGO")).get("img") ;
			if(logoBase64 != null && logoBase64.startsWith("data:image/")){
				if(!new File(path).exists()){
					new File(path).mkdirs() ;
				}
				String suffix = logoBase64.substring(11 , logoBase64.indexOf(";")) ;
				String name = UUID.randomUUID().toString().replaceAll("-", "")+"."+suffix ;
				//将md5图片转换成字节数组
				//byte[] data = Base64.decode(logoBase64.substring(logoBase64.indexOf(",")+1)) ;
				MessageDigest md5Digest = MessageDigest.getInstance("md5");
				//对图片进行md5计算
	            byte[] digest = md5Digest.digest(logoBase64.getBytes());
	            String md5 = HexUtil.encodeHexStr(digest) ;
	            if(!service.isExist(md5)){
	            	FileInfo pictrul = new FileInfo() ;
	            	pictrul.setMd5(md5);
	            	pictrul.setType("img");
	            	pictrul.setUrl("./screen/upload/"+date+"/"+name);
	            	FileInfo p = service.addImg(pictrul) ;
	            	Base64.decodeToFile(logoBase64.substring(logoBase64.indexOf(",")+1), new File(path+separator+name)) ;
	            	((Map)((Map)map.get("panel")).get("VUELOGO")).put("img", p.getUrl()) ;
	            }else{
	            	FileInfo p = service.getImg(md5) ;
	            	((Map)((Map)map.get("panel")).get("VUELOGO")).put("img", p.getUrl()) ;
	            }
			}
			//2.找出内容组件与导航栏中的图片
			List bars = (List)((Map)((Map)map.get("panel")).get("MAIN")).get("data") ;
			for(Object o : bars){
				String barBase64 = (String)((Map)o).get("img") ;
				if(barBase64 != null && barBase64.startsWith("data:image/")){
					if(!new File(path).exists()){
						new File(path).mkdirs() ;
					}
					String suffix = barBase64.substring(11 , barBase64.indexOf(";")) ;
					String name = UUID.randomUUID().toString().replaceAll("-", "")+"."+suffix ;
					//将md5图片转换成字节数组
					//byte[] data = Base64.decode(barBase64.substring(barBase64.indexOf(",")+1)) ;
					MessageDigest md5Digest = MessageDigest.getInstance("md5");
					//对图片进行md5计算
		            byte[] digest = md5Digest.digest(barBase64.getBytes());
		            String md5 = HexUtil.encodeHexStr(digest) ;
		            if(!service.isExist(md5)){
		            	FileInfo pictrul = new FileInfo() ;
		            	pictrul.setMd5(md5);
		            	pictrul.setType("img");
		            	pictrul.setUrl("./screen/upload/"+date+"/"+name);
		            	FileInfo p = service.addImg(pictrul) ;
		            	Base64.decodeToFile(barBase64.substring(barBase64.indexOf(",")+1), new File(path+separator+name)) ;
		            	((Map)o).put("img", p.getUrl()) ;
		            }else{
		            	FileInfo p = service.getImg(md5) ;
		            	((Map)o).put("img", p.getUrl()) ;
		            }
				}
				//找出内容组件中的图片
				List contents = (List)((Map)((Map)o).get("data")).get("info") ;
				for(Object m : contents){
					List<String> imgs = (List<String>)((Map)m).get("imgs") ;
					for (int i=0 ; i<imgs.size() ; i++) {
						if(imgs.get(i) != null && imgs.get(i).startsWith("data:image/")){
							if(!new File(path).exists()){
								new File(path).mkdirs() ;
							}
							String suffix = imgs.get(i).substring(11 , imgs.get(i).indexOf(";")) ;
							String name = UUID.randomUUID().toString().replaceAll("-", "")+"."+suffix ;
							//将md5图片转换成字节数组
							//byte[] data = Base64.decode(imgs.get(i).substring(imgs.get(i).indexOf(",")+1)) ;
							MessageDigest md5Digest = MessageDigest.getInstance("md5");
							//对图片进行md5计算
				            byte[] digest = md5Digest.digest(imgs.get(i).getBytes());
				            String md5 = HexUtil.encodeHexStr(digest) ;
				            if(!service.isExist(md5)){
				            	FileInfo pictrul = new FileInfo() ;
				            	pictrul.setMd5(md5);
				            	pictrul.setUrl("./screen/upload/"+date+"/"+name);
				            	pictrul.setType("img");
				            	FileInfo p = service.addImg(pictrul) ;
				            	Base64.decodeToFile(imgs.get(i).substring(imgs.get(i).indexOf(",")+1), new File(path+separator+name)) ;
				            	imgs.set(i, p.getUrl()) ;
				            }else{
				            	FileInfo p = service.getImg(md5) ;
				            	imgs.set(i, p.getUrl()) ;
				            }
						}
					}
					if(((Map)m).get("apk") != null && !"".equals(((Map)m).get("apk"))) {
						if(((Map)m).get("packageName") != null && "com.woos.ppt".equals(((Map)m).get("packageName"))) {
							List<String> imgsPpt = (List<String>)((Map)m).get("ppt") ;
							if(imgsPpt != null) {
								for (int i=0 ; i<imgsPpt.size() ; i++) {
									if(imgsPpt.get(i) != null && imgsPpt.get(i).startsWith("data:image/")){
										if(!new File(path).exists()){
											new File(path).mkdirs() ;
										}
										String suffix = imgsPpt.get(i).substring(11 , imgsPpt.get(i).indexOf(";")) ;
										String name = UUID.randomUUID().toString().replaceAll("-", "")+"."+suffix ;
										//将md5图片转换成字节数组
										//byte[] data = Base64.decode(imgs.get(i).substring(imgs.get(i).indexOf(",")+1)) ;
										MessageDigest md5Digest = MessageDigest.getInstance("md5");
										//对图片进行md5计算
							            byte[] digest = md5Digest.digest(imgsPpt.get(i).getBytes());
							            String md5 = HexUtil.encodeHexStr(digest) ;
							            if(!service.isExist(md5)){
							            	FileInfo pictrul = new FileInfo() ;
							            	pictrul.setMd5(md5);
							            	pictrul.setUrl("./screen/upload/"+date+"/"+name);
							            	pictrul.setType("img");
							            	FileInfo p = service.addImg(pictrul) ;
							            	Base64.decodeToFile(imgsPpt.get(i).substring(imgsPpt.get(i).indexOf(",")+1), new File(path+separator+name)) ;
							            	imgsPpt.set(i, p.getUrl()) ;
							            }else{
							            	FileInfo p = service.getImg(md5) ;
							            	imgsPpt.set(i, p.getUrl()) ;
							            }
									}
								}
							}
						}
					}
				}
			}
			//没有导航栏时要额外处理一下
			List<Object> l = (List<Object>)((Map)((Map)map.get("panel")).get("MAIN")).get("data") ;
			boolean item = (Boolean) ((Map)((Map)map.get("panel")).get("MAIN")).get("bar") ;
			if(!item){
				int len = l.size() - 1 ;
				for(int i=0 ; i<len ; i++){
					l.remove(l.size() - 1) ;
				}
			}
			//写文件
			File dir = new File(System.getProperty("ROOT_PATH")+"screen"+separator+id+separator+language) ;
			if(!dir.exists()){
				dir.mkdirs() ;
			}
			File file = new File(System.getProperty("ROOT_PATH")+"screen"+separator+id+separator+language+separator+"screen.json") ;
			OutputStreamWriter writer = null ;
			try {
				writer = new OutputStreamWriter(new FileOutputStream(file) , "utf-8") ;
				writer.write("fun_id"+"('"+(map != null ? JSONObject.toJSONString(map) : code)+"')");
			} catch (IOException e) {
				api.setCode(500);
				api.setMsg("存储失败");
				api.setData("");
				return api ;
			} finally{
				if(writer != null){
					try {
						writer.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			
			//System.out.println(map);
			ApiClass saveCode = saveAsAndroidCode(id , map, language) ;
			
			api.setCode(200);
			api.setMsg("上传成功");
			api.setData("");
			return api ;
		}
	}
	
	//保存欢迎界面
	@RequestMapping("/welcome_save")
	@ResponseBody
	public ApiClass welcomePageUpload(String id , String code) throws NoSuchAlgorithmException{
		ApiClass api = new ApiClass() ;
		//写文件
		File dir = new File(System.getProperty("ROOT_PATH")+"screen"+separator+id+separator+"welcome") ;
		if(!dir.exists()){
			dir.mkdirs() ;
		}
		String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()) ;
		String path = System.getProperty("ROOT_PATH")+"screen"+separator+"upload"+separator + date;
		JSONObject json = JSONObject.parseObject(code) ;
		String type = json.getJSONObject("panel").getJSONObject("BG").getString("type") ;
		if(type != null && type.equals("img")) {
			JSONArray array = json.getJSONObject("panel").getJSONObject("BG").getJSONArray("url") ;
			for(int i = 0 ; i < array.size() ; i++) {
				if(array.getString(i) != null && array.getString(i).startsWith("data:image/")){
					if(!new File(path).exists()){
						new File(path).mkdirs() ;
					}
					String suffix = array.getString(i).substring(11 , array.getString(i).indexOf(";")) ;
					String name = UUID.randomUUID().toString().replaceAll("-", "")+"."+suffix ;
					//将md5图片转换成字节数组
					//byte[] data = Base64.decode(imgs.get(i).substring(imgs.get(i).indexOf(",")+1)) ;
					MessageDigest md5Digest = MessageDigest.getInstance("md5");
					//对图片进行md5计算
		            byte[] digest = md5Digest.digest(array.getString(i).getBytes());
		            String md5 = HexUtil.encodeHexStr(digest) ;
		            if(!service.isExist(md5)){
		            	FileInfo pictrul = new FileInfo() ;
		            	pictrul.setMd5(md5);
		            	pictrul.setUrl("./screen/upload/"+date+"/"+name);
		            	pictrul.setType("img");
		            	FileInfo p = service.addImg(pictrul) ;
		            	Base64.decodeToFile(array.getString(i).substring(array.getString(i).indexOf(",")+1), new File(path+separator+name)) ;
		            	array.set(i, p.getUrl()) ;
		            }else{
		            	FileInfo p = service.getImg(md5) ;
		            	array.set(i, p.getUrl()) ;
		            }
				}
			}
		}
		File file = new File(System.getProperty("ROOT_PATH")+"screen"+separator+id+separator+"welcome"+separator+"welcome.json") ;
		OutputStreamWriter writer = null ;
		try {
			writer = new OutputStreamWriter(new FileOutputStream(file) , "utf-8") ;
			writer.write("fun_id"+"('"+json.toJSONString()+"')");
		} catch (IOException e) {
			api.setCode(500);
			api.setMsg("存储失败");
			api.setData("");
			return api ;
		} finally{
			if(writer != null){
				try {
					writer.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return api ;
	}
	
	/**
	 * 上传数据之前进行md5验证，服务器已有的文件返回文件引用
	 * @param data
	 * @return
	 */
	@RequestMapping("/md5Check")
	@ResponseBody
	public ApiClass md5Check(String data){
		Map<String, String> map = null ;
		try{
			map = JSONObject.parseObject(data, Map.class) ;
		}catch(Exception e){
			ApiClass api = new ApiClass() ;
			api.setCode(500);
			api.setMsg("数据异常");
			api.setData("");
			return api ;
		}
		for(Map.Entry<String, String> temp : map.entrySet()){
			FileInfo pictrul = service.getImg(temp.getValue()) ;
			if(pictrul != null){
				map.put(temp.getKey(), temp.getKey()+" = \""+pictrul.getUrl()+"\"") ;
			}else{
				map.put(temp.getKey(), "404") ;
			}
		}
		ApiClass api = new ApiClass() ;
		api.setCode(200);
		api.setMsg("验证结束,开始上传");
		api.setData(map);
		return api ;
	}
	
	/**
	 * @param data 界面数据
	 * @param language 界面所对应的语言
	 * @return 用于判断转换过程中是否报错
	 * {
	 * 		code:"" ,
	 * 		msg:"" ,
	 * 		data:{
	 * 			"CN":{
	 * 				"desktop":{
	 * 					...
	 * 				}
	 * 			} ,
	 * 			"EN:{...}"
	 * 		}
	 * }
	 */
	public ApiClass saveAsAndroidCode(String id , Map data , String language){
		Map result = new HashMap() ;  //结果存储
		result.put("data", new HashMap()) ;
		((Map)result.get("data")).put("CN", new HashMap()) ;
		((Map)result.get("data")).put("EN", new HashMap()) ;
		((Map)result.get("data")).put("SERVER", "http://106.13.59.71/vueDrag") ;
		
		//构造数据结构
		if(language != null && language.equals("CN")){
			((Map)((Map)result.get("data")).get("CN")).put("desktop", new HashMap()) ;
			
			decodeData(data , (Map)((Map)((Map)result.get("data")).get("CN")).get("desktop")) ;
		}else if(language != null && language.equals("EN")){
			((Map)((Map)result.get("data")).get("EN")).put("desktop", new HashMap()) ;
			
			decodeData(data , (Map)((Map)((Map)result.get("data")).get("EN")).get("desktop")) ;
		}
		
		result.put("code", "200") ;
		result.put("msg" , "成功") ;
		
		writeToFile(System.getProperty("ROOT_PATH")+separator+"screen"+separator+id+separator+"android"+separator+"android.json", result , language);
		
		return null ;
	}
	
	public void writeToFile(String file , Map data , String language){
		if(new File(file).exists()){ //当安卓文件已经存在时，仅对当前操作部分修改
			BufferedReader reader = null ;
			BufferedWriter writer = null ;
			try {
				reader = new BufferedReader(new InputStreamReader(new FileInputStream(file) , "utf-8")) ;
				StringBuffer buf = new StringBuffer() ;
				String line = "" ;
				while((line = reader.readLine()) != null){
					buf.append(line) ;
				}
				reader.close();
				
				JSONObject object = JSONObject.parseObject(buf.toString()) ;
				JSONObject object2 = object.getJSONObject("data") ;
				object2.put(language, ((Map)data.get("data")).get(language)) ;
				
				//System.out.println(((Map)data.get("data")).get(language));
				
				writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file) , "utf-8")) ;
				writer.write(JSONObject.toJSONString(object));
				
				writer.close();
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally{
				if(reader != null){
					try {
						reader.close();
					} catch (IOException e) {
						e.printStackTrace();
					} 
				}
				
				if(writer != null){
					try {
						writer.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}else{
			BufferedWriter writer = null ;
			if(!new File(file.replace("android.json", "")).exists()){
				new File(file.replace("android.json", "")).mkdirs() ;
			}
			try{
				writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file) , "utf-8")) ;
				writer.write(JSONObject.toJSONString(data));
				
				writer.close();
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				if(writer != null){
					try {
						writer.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
	}
	
	/**
	 * 将source中的数据按照安卓中的格式转换到data中
	 * @param source 源数据
	 * @param data 目标数据
	 */
	public void decodeData(Map source , Map data){
		
		Map content = (Map)((Map)source).get("panel") ; 
		
		//1.解析全局属性(颜色)
		//data.put("msg", "color,表示跑马灯和天气的颜色 , 组件中pos字段注解:pos表示组件所在的大概位置,t 顶部  , b 下部 , l 左 , r 右 , c 中间 , t-l 左上方 ...,有些参数可能未必有用，后续如果觉得哪个参数无效我再删了,内容组件在1080p分辨率下是以1658*620为面板设计的") ;
		data.put("color", content.get("color")) ;
		
		//解析背景图片
		data.put("bg", ((Map)content.get("BG")).get("img")) ;
		
		
		//2.解析logo
		if(content.get("VUELOGO") != null){
			data.put("logo", new HashMap()) ;
			((Map)data.get("logo")).put("img", ((Map)content.get("VUELOGO")).get("img")) ;
			((Map)data.get("logo")).put("pos", ((Map)content.get("VUELOGO")).get("pos")) ;
		}
		
		//3.解析天气组件
		if(content.get("VUECLOCK") != null){
			data.put("clock", new HashMap()) ;
			((Map)data.get("clock")).put("pos", ((Map)content.get("VUECLOCK")).get("pos")) ;
		}
		
		//4.解析pmd组件
		if(content.get("VUEPMD") != null){
			data.put("pmd", new HashMap()) ;
			((Map)data.get("pmd")).put("pos", ((Map)content.get("VUEPMD")).get("pos")) ;
			((Map)data.get("pmd")).put("dir", ((Map)content.get("VUEPMD")).get("dirction")) ;
			((Map)data.get("pmd")).put("size", ((Map)content.get("VUEPMD")).get("size").toString()) ;
			((Map)data.get("pmd")).put("speed", ((Map)content.get("VUEPMD")).get("speed").toString()) ;
			((Map)data.get("pmd")).put("bkcolor", ((Map)content.get("VUEPMD")).get("bkcolor").toString()) ;
			((Map)data.get("pmd")).put("title", ((Map)content.get("VUEPMD")).get("title")) ;
			((Map)data.get("pmd")).put("color", ((Map)content.get("VUEPMD")).get("color")) ;
			//((Map)data.get("pmd")).put("msg", "pos表示位置 , dir表示跑马灯方向(l向左，r向右) , size跑马灯字体大小(s小，m中，l大) , title跑马灯内容") ;
		}
		
		// 解析边角
		if(content.get("BORDER") != null){
			data.put("border", new HashMap()) ;
			((Map)data.get("border")).put("type", ((Map)content.get("BORDER")).get("type")) ;
			((Map)data.get("border")).put("color", ((Map)content.get("BORDER")).get("color")) ;
		}
		
		//5.解析导航栏和内容组件
		if(content.get("MAIN") != null){
			Map bar = (Map) content.get("MAIN") ;
			//当有导航栏时怎么处理
			data.put("main", new HashMap()) ;
			//导航栏类型
			((Map)data.get("main")).put("type" , bar.get("type")) ;
			((Map)data.get("main")).put("pos" , bar.get("pos")) ;
			if(Boolean.parseBoolean(bar.get("bar").toString())){
				((Map)data.get("main")).put("exist" , true) ;
			}else{
				((Map)data.get("main")).put("exist" , false) ;
			}
			List d = (List) bar.get("data") ;
			((Map)data.get("main")).put("data" , new ArrayList()) ;
			for(int i=0 ; i<d.size(); i++){
				//遍历每一个导航栏
				Map m = new HashMap() ;
				//获取导航栏图标地址
				String img = (String) ((Map)d.get(i)).get("img") ;
				String name = (String) ((Map)d.get(i)).get("name") ;
				m.put("icon", img) ;
				m.put("name", name) ;
				if(((Map)d.get(i)).get("def") != null) {
					m.put("defaultApk", ((Map)d.get(i)).get("defaultApk")) ;
				}
				//内容组件
				((Map)((Map)d.get(i)).get("data")).put("layout", service.getLayout(((Map)((Map)d.get(i)).get("data")).get("id").toString())) ;
				m.put("content", ((Map)d.get(i)).get("data")) ;
				((List)((Map)data.get("main")).get("data")).add(m) ;
			}
		}
	}
	
	@GetMapping("/upload")
	public ApiClass err(){
		return new ApiClass(404, "非法请求", "") ;
	}
	
	//视频上传接口
	@PostMapping("/upload")
	@ResponseBody
	public ApiClass movieUpload(MultipartFile file){	
		if(file.isEmpty()){
			return new ApiClass(500 , "无数据" , "") ;
		}
		
		String fileName = file.getOriginalFilename() ;
		String suffix = fileName.substring(fileName.lastIndexOf(".")) ;
		FileOutputStream out = null ;
		if(".mp4".equals(suffix) || ".avi".equals(suffix) || ".mp3".equals(suffix)){
			String newFile = UUID.randomUUID().toString().replaceAll("-", "")+suffix ;
			try {
				byte[] data = file.getBytes() ;
				MessageDigest md5Digest = MessageDigest.getInstance("md5");
				byte[] md5b = md5Digest.digest(data) ;
				String md5 = HexUtil.encodeHexStr(md5b) ;
				
				//验证一下文件是否存在
//				if(service.isExist(md5)){
//					return new ApiClass(200, "成功", service.getImg(md5).getUrl()) ;
//				}
				
				//存储区域
				String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()) ;
				String path = System.getProperty("ROOT_PATH")+"temp"+separator + date;
				
				if(!new File(path).exists()){
					new File(path).mkdirs() ;
				}
				
				out = new FileOutputStream(path+separator+newFile) ;
				out.write(data);
				out.close();
				
				FileInfo video = new FileInfo() ;
				video.setMd5(md5);
				video.setType("video");
				video.setUrl("./temp/"+date+"/"+newFile);
				service.addImg(video) ;
				
				return new ApiClass(200, "成功", "./temp/"+date+"/"+newFile) ;
			} catch (Exception e) {
				e.printStackTrace();
				return new ApiClass(500 , "文件数据异常" , "") ;
			} finally{
				if(out != null){
					try {
						out.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		} 
		
		return new ApiClass(500, "文件类型不支持", "") ;
	}
	
}
