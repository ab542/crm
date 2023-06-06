package com.bjpowernode.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 理论上，给controller方法分配url：http：//127.0.0.1：8080/crm
 * 为了简便，协议等等都应省去，用/代表应用根目录下的/
 */
@Controller
public class IndexController {

    @RequestMapping("/")
    public String index(){
        //请求转发（内部可进入web-inf（视图解析器 跳转时自动加上前缀后缀））
        return "index";
    }
}

