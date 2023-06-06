package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.setting.model.User;
import com.bjpowernode.crm.workbench.model.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.UUID;

@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    public @ResponseBody Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession httpSession){
        System.out.println("备注执行中");
        ReturnObject returnObject = new ReturnObject();
        User user = (User)httpSession.getAttribute(Contants.SESSION_USER);
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateBy(user.getId());
        activityRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setEditFlag("0");
        try{
            int i = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if(i>0){
                returnObject.setCode("1");
                returnObject.setRetData(activityRemark);
            }else{
                returnObject.setCode("0");
                returnObject.setMessage("系统忙");
            }

        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode("0");
            returnObject.setMessage("系统忙");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    public @ResponseBody Object deleteActivityRemarkById(String id){
        System.out.println("删除市场活动备注执行中");
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityRemarkService.deleteActivityRemarkById(id);
            if(i>0){
                returnObject.setCode(Contants.RETURN_CODE_SUCCESS);
                returnObject.setMessage("成功");
            }else{
                returnObject.setCode(Contants.RETURN_CODE_FAIL);
                returnObject.setMessage("系统忙");
            }

        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_CODE_FAIL);
            returnObject.setMessage("系统忙");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public @ResponseBody Object saveEditActivityRemark(ActivityRemark activityRemark,HttpSession httpSession){
        User  user=(User)httpSession.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        activityRemark.setEditFlag("1");
        activityRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setEditBy(user.getId());
        System.out.println(activityRemark.getId()+"执行中id");
        try{
            int i = activityRemarkService.saveEditActivityRemark(activityRemark);
            if(i>0){
                returnObject.setCode(Contants.RETURN_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            }else{
                returnObject.setCode(Contants.RETURN_CODE_FAIL);
                returnObject.setMessage("系统忙");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_CODE_FAIL);
            returnObject.setMessage("系统忙");
        }
        return returnObject;

    }
}
