package org.rec.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public class IndexController {
	public ModelAndView index(HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView result=new ModelAndView();
		return result;
	}
}
