package com.bjpowernode.crm.setting.service;

import com.bjpowernode.crm.setting.model.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User  queryByLoginActAndPwd(Map<String,Object> map);
    List<User>  queryAllUsers();
}
