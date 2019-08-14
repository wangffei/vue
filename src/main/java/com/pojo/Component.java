package com.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;


/**
 * 此类用于描述组件
 * @author wangfei
 *
 */
public class Component {
	//组件id
	@TableId(type=IdType.AUTO)
	private Integer id ;
	//组件名称
	private String name ;
	//组件类型(映射位置表中的数据(json数据))
	private String types ;
	//组件代码
	private String code ;
	//组件展示图片
	private String img ;
	//组件图片显示宽度高度
	private String width ;
	private String height ;
	//组件描述内容
	private String msg ;
	//组件布局信息
	private String area ;
	
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getTypes() {
		return types;
	}
	public void setTypes(String types) {
		this.types = types;
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
