package com.bjpowernode.crm.workbench;

import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.Map;


public class PageTest {
    @Autowired
    ActivityMapper activityMapper;
    @Test
    public void test1(){
        Map<String,Object> map = new HashMap<>();
        map.put("name", null);
        map.put("owner",null);
        map.put("startDate",null);
        map.put("endDate",null);
        map.put("beginNo", "0");
        map.put("pageSize","2");
        System.out.println(activityMapper.selectActivityByConditionForPage(map));
    }
}
