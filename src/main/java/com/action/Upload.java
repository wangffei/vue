package com.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.vo.ApiClass;

/**
 * 文件上传
 * @author wangfei
 *
 */
@Controller
public class Upload {
	
	@RequestMapping("/upload")
	public String upload(){
		
		return null ;
	}
	
	/**
	 * 界面文件上传
	 * @param language 界面语言
	 * @param code     界面代码
	 * @return		     返回部分不满足分辨率的图片
	 */
	@RequestMapping("/pageUpload")
	@ResponseBody
	public ApiClass page(String language , String id , String code){
		ApiClass api = new ApiClass() ;
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
		if("CN".equals(language)){
			if(code == null || code.equals("")){
				api.setCode(500);
				api.setMsg("界面数据异常");
				api.setData("");
				return api ;
			}else{
				//Map<String, Object> map = JSONObject.parseObject(code, Map.class) ;
				//写文件
				File dir = new File(System.getProperty("ROOT_PATH")+"screen/"+id) ;
				if(!dir.exists()){
					dir.mkdirs() ;
				}
				File file = new File(System.getProperty("ROOT_PATH")+"screen/"+id+"/screen.json") ;
				OutputStreamWriter writer = null ;
				try {
					writer = new OutputStreamWriter(new FileOutputStream(file) , "utf-8") ;
					writer.write("fun_id_"+id+"('"+code+"')");
					System.out.println("laile");
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
			}
		}
		return null ;
	}
	
}
