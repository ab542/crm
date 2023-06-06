package com.bjpowernode.crm.setting.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.setting.model.User;
import com.bjpowernode.crm.setting.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    //注入
    @Autowired
    private UserService userService;

    /**
     * url要和controller方法处理完成请求之后，
     * 响应信息返回的页面的资源目录保持一致
     *
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession httpSession, HttpServletResponse httpResponse){
        //真正转json，按照子类型（多态），定义返回值类型可以是父类 /封装参数
        Map<String, Object> map = new HashMap<>();
        System.out.println(loginAct + ":" + loginPwd);
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        //调用service层方法 查询用户
        User user = userService.queryByLoginActAndPwd(map);
        ReturnObject returnObject = new ReturnObject();
        //根据查询结果生成响应信息
        if (user == null) {//登录失败（用户名或密码错误）
            returnObject.setCode("0");
            returnObject.setMessage("用户名或密码错误");
        } else {//进一步判断账号是否合法
            String expireTime = user.getExpireTime();
            String format = DateUtils.formateDateTime(new Date());
            if (format.compareTo(user.getExpireTime()) > 0) {
                //过期了 登录失败 账号以过期
                returnObject.setCode(Contants.RETURN_CODE_FAIL);
                returnObject.setMessage("账号过期");
            } else if ("0".equals(user.getLockState())) {//判断状态是否被锁定
                //登录失败，账号被锁定
                returnObject.setCode(Contants.RETURN_CODE_FAIL);
                returnObject.setMessage("账号被锁定");
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {//判断ip地址是否正确
                //登录失败，IP不匹配
                returnObject.setCode(Contants.RETURN_CODE_FAIL);
                returnObject.setMessage("IP不匹配");
            } else {
                //登录成功
                returnObject.setCode(Contants.RETURN_CODE_SUCCESS);
                returnObject.setMessage("登录成功");
                //把user保存到session中
                httpSession.setAttribute(Contants.SESSION_USER, user);

                //如果需要记住密码，则往外写cookie
                if ("true".equals(isRemPwd)) {
                    Cookie cookie = new Cookie("loginAct", user.getLoginAct());
                    cookie.setMaxAge(10 * 24 * 60 * 60);//十天
                    httpResponse.addCookie(cookie);
                    Cookie cookie1 = new Cookie("loginPwd", user.getLoginPwd());
                    cookie1.setMaxAge(10 * 24 * 60 * 60);//十天
                    httpResponse.addCookie(cookie1);
                } else {
                    //去掉记住密码 删cookie(不可删) 直接再次生成一个tongmingcookie把之前的覆盖，过期时间设为0
                    Cookie cookie = new Cookie("loginAct", "1");
                    cookie.setMaxAge(0);
                    httpResponse.addCookie(cookie);
                    Cookie cookie1 = new Cookie("loginPwd", "1");
                    cookie1.setMaxAge(0);
                    httpResponse.addCookie(cookie1);
                }
            }
        }
            return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse httpServletResponse,HttpSession httpSession) {
        //清空cookie
        Cookie cookie = new Cookie("loginAct", "1");
        cookie.setMaxAge(0);
        httpServletResponse.addCookie(cookie);
        Cookie cookie1 = new Cookie("loginPwd", "1");
        cookie1.setMaxAge(0);
        httpServletResponse.addCookie(cookie1);
        //销毁session
        httpSession.invalidate();//把seesion数据销毁
        //跳转到首页(重定向)  借助springmvc框架来重定向 翻译成底层=response。senRedirect("/crm/");
        return "redirect:/";
    }


}
