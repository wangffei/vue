package com.pojo;

/**
 * 此类用于描述设计的屏幕所使用到的组件
 * @author Administrator
 *
 */
public class Screen {
	//该电视所对应的id
	private Integer id ;
	//导航栏
	private Integer did ;
	//logo组件
	private Integer lid ;
	//内容组件
	private Integer nid ;
	//时钟组件
	private Integer sid ;
	//跑马灯组件
	private Integer pid ;
	//文件路径
	private String file ;
	
	public String getFile() {
		return file;
	}
	public void setFile(String file) {
		this.file = file;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getDid() {
		return did;
	}
	public void setDid(Integer did) {
		this.did = did;
	}
	public Integer getLid() {
		return lid;
	}
	public void setLid(Integer lid) {
		this.lid = lid;
	}
	public Integer getNid() {
		return nid;
	}
	public void setNid(Integer nid) {
		this.nid = nid;
	}
	public Integer getSid() {
		return sid;
	}
	public void setSid(Integer sid) {
		this.sid = sid;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
}
