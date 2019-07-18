package com.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;

/**
 * 此类用于描述各个组件可以存在的位置，用于后台动态的增加电视机界面的布局
 * @author wangfei
 *
 */
public class Position {
	//id
	@TableId(type=IdType.AUTO)
	private Integer id ;
	//组件类型
	private String type ;
	//组件位置(json数据)
	private String pos ;
	//组件大小(设置占屏比)
	private String width ;
	private String height ;
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getPos() {
		return pos;
	}
	public void setPos(String pos) {
		this.pos = pos;
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
