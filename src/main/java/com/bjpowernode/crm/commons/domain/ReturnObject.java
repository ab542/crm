package com.bjpowernode.crm.commons.domain;
//返回json 字符串的对象
public class ReturnObject {
    private String code;//处理成功或失败的表示 1成功 0失败
    private String message;//提示信息
    private Object retData;//其它数据

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }
}
