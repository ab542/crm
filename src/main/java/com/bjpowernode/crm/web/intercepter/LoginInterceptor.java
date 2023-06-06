package com.bjpowernode.crm.web.intercepter;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.setting.model.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {
    //到达目标资源之前 进行登录验证，如果成功 放行进入资源目标
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        //判断是否登录成功
        //如果用户没有登录成功，则跳转到登录页面
        HttpSession session = httpServletRequest.getSession();

        User attribute = (User) session.getAttribute(Contants.SESSION_USER);
        if(attribute==null){
            //未登录  对于自己重定向 要加项目名字
            httpServletResponse.sendRedirect(httpServletRequest.getContextPath());
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
