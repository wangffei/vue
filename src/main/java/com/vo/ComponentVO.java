package com.vo;

import java.util.List;


public class ComponentVO {
	//组件id
	private Integer id ;
	//组件名称
	private String name ;
	//组件类型(映射位置表中的数据(json数据))
	private List<Integer> positions ;
	//组件代码
	private String code ;
	//组件展示图片
	private String img ;
	//组件图片显示宽度高度
	private String width ;
	private String height ;
	//组件描述内容
	private String msg ;
	
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public List<Integer> getPositions() {
		return positions;
	}
	public void setPositions(List<Integer> positions) {
		this.positions = positions;
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
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
}
