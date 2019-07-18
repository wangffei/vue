package com.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.hutool.core.bean.BeanUtil;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.dao.ComponentDao;
import com.dao.ContentDao;
import com.dao.PositionDao;
import com.pojo.Component;
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
		List<Component> list = component.selectList(null) ;
		List<ComponentVO> newList = new ArrayList<ComponentVO>() ;
		for(Component p : list){
			ComponentVO pos = new ComponentVO() ;
			BeanUtil.copyProperties(p, pos, "types") ;
			pos.setPositions(JSONArray.parseObject(p.getTypes(), List.class));
			newList.add(pos) ;
		}
		return  newList ;
	}
}
