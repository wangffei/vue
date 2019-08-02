package com.vo;

import java.util.Map;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;

public class PositionVO {
	//id
	@TableId(type=IdType.AUTO)
	private Integer id ;
	//组件类型
	private String type ;
	//组件位置(json数据)
	private Map<String , String> position ;
	//组件大小(设置占屏比)
	private String width ;
	private String height ;
	private String msg ;
	
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Map<String, String> getPosition() {
		return position;
	}
	public void setPosition(Map<String, String> position) {
		this.position = position;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
}
