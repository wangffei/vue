package com.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;

/**
 * 图片表
 * @author wangfei
 *
 */
public class Pictrul {
	//图片id
	@TableId(type=IdType.AUTO)
	private Integer id ;
	//图片md5值
	private String md5 ;
	//图片地址
	private String url ;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getMd5() {
		return md5;
	}
	public void setMd5(String md5) {
		this.md5 = md5;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
}
