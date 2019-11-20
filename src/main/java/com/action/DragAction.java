package com.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.service.DragService;
import com.vo.ComponentVO;
import com.vo.PositionVO;

/**
 * 此类全部接口用于处理电视布局编辑
 * @author wangfei
 *
 */
@Controller
public class DragAction {
	
	//注入业务层
	@Autowired
	private DragService service ;
	
	//此方法用于访问重定向（因页面要实现渲染部分数据库内容，所以必须通过此接口才能访问编辑页面）
	@RequestMapping("/screen")
	private String jumpToJSP(HttpServletRequest request , String id , String language){
		if(id == null || language == null){
			return "/vuePage/error.html" ;
		}
		//查出所有组件
		List<ComponentVO> components = service.getAllComponents() ;
		request.setAttribute("components", components);
		//查出所有组件所在位置
		//System.out.println(service.getPositions().get(0).getType());
		List<PositionVO> positions = service.getPositions() ;
		request.setAttribute("list", positions);  
		//将组件和位置进行结合，拼接出一个json数组，用于控制面板中显示的组件
		JSONObject array = JSONObject.parseObject("{\"CONTENT\":[],\"VUELOGO\":[],\"VUECLOCK\":[],\"BAR\":[],\"VUEPMD\":[]}") ;
		JSONObject init = new JSONObject() ;
		for(ComponentVO item : components){
			for(PositionVO i : positions){
				List<Integer> te = item.getPositions() ;
				if(JSONObject.parseObject(te.get(0)+"").getInteger("name") == i.getId()){
					JSONObject com = new JSONObject() ;
					com.put("id", item.getId()) ;
					com.put("name", item.getName()) ;
					com.put("img", item.getImg()) ;
					com.put("width", item.getWidth()) ;
					com.put("height", item.getHeight()) ;
					com.put("msg", item.getMsg()) ;
					com.put("type", i.getType()) ;
					com.put("positions", item.getPositions()) ;
					array.getJSONArray(i.getType()).add(com) ;
				}
				if(init.get(i.getId()) == null){
					init.put(i.getId()+"" , new JSONObject()) ;
				}
				for(int j=0 ; j<te.size() ; j++){
					if(JSONObject.parseObject(te.get(j)+"").getInteger("name") == i.getId()){
						JSONObject jsonObject = init.getJSONObject(i.getId()+"") ;
						jsonObject.put(item.getId()+"", false) ;
						jsonObject.put(item.getId()+"woos" , item.getName()) ;
					}
				}
			}
		}
		request.setAttribute("array", array.toString());
		request.setAttribute("init", init.toString());
		request.setAttribute("id", id);
		request.setAttribute("language", language);
		return "forward:/vuePage/index.jsp" ;
	}
	
}
