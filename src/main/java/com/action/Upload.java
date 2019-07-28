package com.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.util.HexUtil;

import com.alibaba.fastjson.JSONObject;
import com.pojo.Pictrul;
import com.service.DragService;
import com.vo.ApiClass;

/**
 * 文件上传下载
 * @author wangfei
 * 图片上传时间太长的解决方案（进行md5对比，相同的图片不上传）
 */
@Controller
public class Upload {
	
	@Autowired
	private DragService service ;
	
	@RequestMapping("/upload")
	public String upload(){
		
		return null ;
	}
	
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
			String path = System.getProperty("ROOT_PATH")+"screen\\images\\" + date;
			//找出背景图片
			String bgBase64 = (String)((Map)((Map)map.get("panel")).get("BG")).get("img") ;
			if(bgBase64.startsWith("data:image/")){
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
	            	Pictrul pictrul = new Pictrul() ;
	            	pictrul.setMd5(md5);
	            	pictrul.setUrl("./screen/images/"+date+"/"+name);
	            	Pictrul p = service.addImg(pictrul) ;
	            	Base64.decodeToFile(bgBase64.substring(bgBase64.indexOf(",")+1), new File(path+"\\"+name)) ;
	            	((Map)((Map)map.get("panel")).get("BG")).put("img", p.getUrl()) ;
	            }else{
	            	Pictrul p = service.getImg(md5) ;
	            	((Map)((Map)map.get("panel")).get("BG")).put("img", p.getUrl()) ;
	            }
			}
			//1.找出logo中的图片
			String logoBase64 = (String)((Map)((Map)map.get("panel")).get("VUELOGO")).get("img") ;
			if(logoBase64.startsWith("data:image/")){
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
	            	Pictrul pictrul = new Pictrul() ;
	            	pictrul.setMd5(md5);
	            	pictrul.setUrl("./screen/images/"+date+"/"+name);
	            	Pictrul p = service.addImg(pictrul) ;
	            	Base64.decodeToFile(logoBase64.substring(logoBase64.indexOf(",")+1), new File(path+"\\"+name)) ;
	            	((Map)((Map)map.get("panel")).get("VUELOGO")).put("img", p.getUrl()) ;
	            }else{
	            	Pictrul p = service.getImg(md5) ;
	            	((Map)((Map)map.get("panel")).get("VUELOGO")).put("img", p.getUrl()) ;
	            }
			}
			//2.找出内容组件与导航栏中的图片
			List bars = (List)((Map)((Map)map.get("panel")).get("MAIN")).get("data") ;
			for(Object o : bars){
				String barBase64 = (String)((Map)o).get("img") ;
				if(barBase64.startsWith("data:image/")){
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
		            	Pictrul pictrul = new Pictrul() ;
		            	pictrul.setMd5(md5);
		            	pictrul.setUrl("./screen/images/"+date+"/"+name);
		            	Pictrul p = service.addImg(pictrul) ;
		            	Base64.decodeToFile(barBase64.substring(barBase64.indexOf(",")+1), new File(path+"\\"+name)) ;
		            	((Map)o).put("img", p.getUrl()) ;
		            }else{
		            	Pictrul p = service.getImg(md5) ;
		            	((Map)o).put("img", p.getUrl()) ;
		            }
				}
				//找出内容组件中的图片
				List contents = (List)((Map)((Map)o).get("data")).get("info") ;
				for(Object m : contents){
					List<String> imgs = (List<String>)((Map)m).get("imgs") ;
					for (int i=0 ; i<imgs.size() ; i++) {
						if(imgs.get(i).startsWith("data:image/")){
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
				            	Pictrul pictrul = new Pictrul() ;
				            	pictrul.setMd5(md5);
				            	pictrul.setUrl("./screen/images/"+date+"/"+name);
				            	Pictrul p = service.addImg(pictrul) ;
				            	Base64.decodeToFile(imgs.get(i).substring(imgs.get(i).indexOf(",")+1), new File(path+"\\"+name)) ;
				            	imgs.set(i, p.getUrl()) ;
				            }else{
				            	Pictrul p = service.getImg(md5) ;
				            	imgs.set(i, p.getUrl()) ;
				            }
						}
					}
				}
			}
			//写文件
			File dir = new File(System.getProperty("ROOT_PATH")+"screen/"+id+"/"+language) ;
			if(!dir.exists()){
				dir.mkdirs() ;
			}
			File file = new File(System.getProperty("ROOT_PATH")+"screen/"+id+"/"+language+"/screen.json") ;
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
			api.setCode(200);
			api.setMsg("上传成功");
			api.setData("");
			return api ;
		}
	}
	
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
			Pictrul pictrul = service.getImg(temp.getValue()) ;
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
}
