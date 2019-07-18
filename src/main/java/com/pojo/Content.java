package com.pojo;

/**
 * 此类用于描述一个电视机显示屏中各个空间之间的关系
 * @author wangfei	
 *
 */
public class Content {
	//id
	private Integer id ;
	//电视机的id
	private Integer screenid ;
	//json代码
	private String code ;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getScreenid() {
		return screenid;
	}
	public void setScreenid(Integer screenid) {
		this.screenid = screenid;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	
}
