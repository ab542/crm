package com.bjpowernode.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 对日期类数据进行处理的工具类
 */
public class DateUtils {
    public static String formateDateTime(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
        String format = simpleDateFormat.format(date);
        return format;
    }

    /**
     * date只有年月日
     * @param date
     * @return
     */
    public static String formateDate(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("YYYY-MM-dd");
        String format = simpleDateFormat.format(date);
        return format;
    }

    public static String formateTime(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
        String format = simpleDateFormat.format(date);
        return format;
    }
}

