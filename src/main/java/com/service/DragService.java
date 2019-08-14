package com.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.hutool.core.bean.BeanUtil;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.dao.ComponentDao;
import com.dao.ContentDao;
import com.dao.PictrulDao;
import com.dao.PositionDao;
import com.pojo.Component;
import com.pojo.FileInfo;
import com.pojo.Position;
import com.vo.ComponentVO;
import com.vo.PositionVO;

/**
 * 此类主要用于处理编辑电视屏幕业务
 * @author wangfei
 *
 */
@Service
public class DragService {
	//组件表
	@Autowired
	private ComponentDao component ;
	//组件位置表
	@Autowired
	private PositionDao position ;
	//屏幕内容表
	@Autowired
	private ContentDao content ;
	//图片表
	@Autowired
	private PictrulDao pictrul ;
	
	//查询各个组件位置表中全部数据
	public List<PositionVO> getPositions(){
		List<Position> list = position.selectList(null) ;
		List<PositionVO> newList = new ArrayList<PositionVO>() ;
		for(Position p : list){
			PositionVO pos = new PositionVO() ;
			BeanUtil.copyProperties(p, pos, "pos") ;
			pos.setPosition(JSONObject.parseObject(p.getPos(), Map.class));
			newList.add(pos) ;
		}
		return  newList ;
	}
	
	//查询出所有组件
	public List<ComponentVO> getAllComponents(){
		QueryWrapper<Component> query = new QueryWrapper<Component>() ;
		query.select("id" , "name" , "types" , "code" , "img" , "width" , "height") ;
		List<Component> list = component.selectList(query) ;
		List<ComponentVO> newList = new ArrayList<ComponentVO>() ;
		for(Component p : list){
			ComponentVO pos = new ComponentVO() ;
			BeanUtil.copyProperties(p, pos, "types") ;
			pos.setPositions(JSONArray.parseObject(p.getTypes(), List.class));
			newList.add(pos) ;
		}
		return  newList ;
	}
	
	//将图片写入数据库
	public FileInfo addImg(FileInfo p){
		pictrul.insert(p) ;
		return p ;
	}
	
	//根据md5值查询图片
	public boolean isExist(String md5){
		QueryWrapper<FileInfo> query = new QueryWrapper<FileInfo>() ;
		query.eq(true, "md5", md5) ;
		FileInfo p = pictrul.selectOne(query) ;		
		if(p != null){
			return true ;
		}
		return false ;
	}
	
	//根据md5查出对应图片的信息
	public FileInfo getImg(String md5){
		QueryWrapper<FileInfo> query = new QueryWrapper<FileInfo>() ;
		query.eq(true, "md5", md5) ;
		FileInfo p = pictrul.selectOne(query) ;
		return p ;
	}
	
	//根据内容组件id获取组件布局
	public String getLayout(String id){
		
		QueryWrapper<Component> query = new QueryWrapper<Component>() ;
		query.select("area") ;
		query.eq(true , "id" , id) ;
		
		Component c = component.selectOne(query) ;
		
		if(c != null){
			return c.getArea() ;
		}
		
		return null ;
	}
}
