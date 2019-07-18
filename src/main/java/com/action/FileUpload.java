package com.action;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 文件上传
 * @author wangfei
 *
 */
@Controller
public class FileUpload {
	
	@RequestMapping("/upload")
	public String upload(){
		
		return null ;
	}
	
}
