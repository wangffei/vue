package com.action;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.service.DragService;

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
	private String jumpToJSP(HttpServletRequest request){
		//查出所有组件
		request.setAttribute("components", service.getAllComponents());
		//查出所有组件所在位置
		//System.out.println(service.getPositions().get(0).getType());
		request.setAttribute("list", service.getPositions());  ;
		return "forward:index.jsp" ;
	}
	
}
