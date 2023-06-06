package com.bjpowernode.crm.workbench.service;


import com.bjpowernode.crm.workbench.model.Activity;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveActivity(Activity activity);
    List<Activity>  queryActivityByConditionForPage(Map<String,Object> map);
    int queryCountByCondition(Map<String,Object> map);
    int deleteActivityByIds(String[] ids);
    Activity queryActivityById(String id);
    int updateActivityById(Activity activity);
    List<Activity> queryAllActivities();
    int saveCreateActivityByList(List<Activity> activityList);
    Activity queryActivityForDetailById(String id);
}
