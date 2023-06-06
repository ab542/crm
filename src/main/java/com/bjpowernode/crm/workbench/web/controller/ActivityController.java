package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.HSSFUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.setting.model.User;
import com.bjpowernode.crm.setting.service.UserService;
import com.bjpowernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpowernode.crm.workbench.model.Activity;
import com.bjpowernode.crm.workbench.model.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest httpServletRequest) {
        //调用service方法查询所有用户
        List<User> userList = userService.queryAllUsers();
        httpServletRequest.setAttribute("userList", userList);
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveActivity(Activity activity, HttpSession httpSession) {//方法返回值定义的父类的类型，真正返回的是子类的对象
        //封装参数

        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        User user = (User) httpSession.getAttribute(Contants.SESSION_USER);
        activity.setCreateBy(user.getId());
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityService.saveActivity(activity);
            if (i > 0) {
                returnObject.setCode(Contants.RETURN_CODE_SUCCESS);
                // returnObject.setMessage("创建成功");
            } else {
                returnObject.setCode(Contants.RETURN_CODE_FAIL);
                returnObject.setMessage("创建失败:添加失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_CODE_FAIL);
            returnObject.setMessage("创建失败:添加失败");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody
    Map<String, Object> queryActivityByConditionForPage(String name, String owner, String startDate, String endDate, int pageNo, int pageSize) {
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Activity> activities = activityService.queryActivityByConditionForPage(map);
        System.out.println(activities);
        int count = activityService.queryCountByCondition(map);
        System.out.println(count);

        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList", activities);
        retMap.put("totalRows", count);
        return retMap;
    }


    @RequestMapping("/workbench/activity/removeActivityByIds.do")
    public @ResponseBody
    Object removeActivityByIds(String[] id) {
        System.out.println("0000:" + id);
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityService.deleteActivityByIds(id);
            if (i > 0) {//删除成功
                returnObject.setCode("1");
            } else {//删除失败
                returnObject.setCode("0");
                returnObject.setMessage("系统繁忙 请稍后");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode("0");
            returnObject.setMessage("系统繁忙 请稍后");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    public @ResponseBody
    Activity queryActivityById(String id) {
        System.out.println("执行中");
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/updateActivityById.do")
    public @ResponseBody
    Object updateActivityById(Activity activity, HttpSession httpSession) {
        User user = (User) httpSession.getAttribute(Contants.SESSION_USER);
        activity.setEditBy(DateUtils.formateDateTime(new Date()));
        activity.setEditBy(user.getId());
        System.out.println("更新中");
        System.out.println(activity);
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = activityService.updateActivityById(activity);
            if (i > 0) {//修改成功
                returnObject.setCode("1");
            } else {//修改失败
                returnObject.setCode("0");
                returnObject.setMessage("系统繁忙 请稍后");
            }
        } catch (Exception e) {
            System.out.println("报错了");
            e.printStackTrace();
            returnObject.setCode("0");
            returnObject.setMessage("系统繁忙 请稍后");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/fileDownLoad.do")
    public void fileDownLoad(HttpServletResponse httpServletResponse) throws IOException {
        System.out.println("下载中");
        //1,设置响应类型
       // httpServletResponse.setContentType("text/html;charset=UTF-8");
          httpServletResponse.setContentType("application/octet-stream;charset=UTF-8");
          //2.获取输出流
          OutputStream outputStream = httpServletResponse.getOutputStream();

          //浏览器接收到响应信息之后，默认情况下，直接在显示窗口打开响应信息；即使它打不开，也会调用电脑上的应用程序，只有实在打不开，才会激活文件下载窗口
          //直接激活文件下载页面
          //可以设置响应头信息，使浏览器接收到响应信息之后，直接激活文件下载窗口。
          httpServletResponse.addHeader("Content-Disposition","attachment;filename=activities.xls");

        /**
         * 思路：首先通过程序读取数据库磁盘里的文件，然后将读入的写入到浏览器
         */
         //1.读取excel文件（inputStream），把输出到浏览器（outputStream）
        FileInputStream fileInputStream = new FileInputStream("D:\\activities.xls");//位于服务器

        byte[] buff = new byte[256];
        int len=0;
        /**
         * 从磁盘到内存  也是从磁盘读，也得建立对硬盘的连接，效率是十分低的
         * 解决方法：直接内存到内存，不用存到磁盘，再读
         * 怎么内存到内存？
         * 正好workbook提供了一个方法 可以内存到内存
         */
        while ((len=fileInputStream.read(buff))!=-1){
            outputStream.write(buff,0,len);
        }
        //关闭资源原则，谁开启谁关闭
        fileInputStream.close();
        outputStream.flush();//这是tomcat开启

    }


    /**
     * 导出
     * @param httpServletResponse
     * @throws IOException
     */
    @RequestMapping("/workbench/activity/outportAllActivities.do")
    public void outportAllActivities(HttpServletResponse httpServletResponse) throws IOException {

        //1.获取到全部市场活动列表
        List<Activity> activities = activityService.queryAllActivities();
        System.out.println("正在执行中（已经入controller）"+activities);
        //2.将所有市场活动列表装入exel中
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheetActivities = workbook.createSheet("市场活动表");
        HSSFRow row = sheetActivities.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell=row.createCell(1);
        cell.setCellValue("所有者");
        cell=row.createCell(2);
        cell.setCellValue("名称");
        cell=row.createCell(3);
        cell.setCellValue("开始日期");
        cell=row.createCell(4);
        cell.setCellValue("结束日期");
        cell=row.createCell(5);
        cell.setCellValue("成本");
        cell=row.createCell(6);
        cell.setCellValue("描述");
        cell=row.createCell(7);
        cell.setCellValue("创建时间");
        cell=row.createCell(8);
        cell.setCellValue("创建者");
        cell=row.createCell(9);
        cell.setCellValue("修改时间");
        cell=row.createCell(10);
        cell.setCellValue("修改者");

        //表中的值
        Activity activity =null;
        if(activities!=null&&activities.size()>0){
            for (int i = 0; i < activities.size(); i++) {
               activity=activities.get(i);
                row = sheetActivities.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell=row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell=row.createCell(2);
                cell.setCellValue(activity.getName());
                cell=row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell=row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell=row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell=row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell=row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell=row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell=row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell=row.createCell(10);
                cell.setCellValue(activity.getCreateBy());
            }
        }

        //将所有数据封装到workbook对象中去了
//        FileOutputStream fileOutputStream = new FileOutputStream("D:\\activities.xls");
//        workbook.write(fileOutputStream);

    //    fileOutputStream.close();
      //  workbook.close();

        //现在完成文件下载功能，文件通过以上就存在了"D:\\activities.xls"
        //现在向浏览器传文件


        // httpServletResponse.setContentType("text/html;charset=UTF-8");

        httpServletResponse.setContentType("application/octet-stream;charset=UTF-8");
        httpServletResponse.addHeader("Content-Disposition","attachment;filename=activities.xls");
        //2.获取输出流
        OutputStream outputStream = httpServletResponse.getOutputStream();
//        FileInputStream fileInputStream = new FileInputStream("D:\\activities.xls");
//
//        byte[] buff = new byte[256];
//        int len=0;
//        while(((len=fileInputStream.read(buff))!=-1)){
//            outputStream.write(buff,0,len);
//        }
//
//        fileInputStream.close();
        workbook.write(outputStream);
        workbook.close();
        outputStream.flush();
    }

    //文件上传
     @RequestMapping("/workbench/activity/upLoadFile.do")
    public @ResponseBody Object upLoadFile(String name, MultipartFile file) throws Exception{
        System.out.println(name);
        file.transferTo(new File("D:/file/",file.getOriginalFilename()));

        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode("1");
        returnObject.setMessage("上传成功");
        return  returnObject;
    }

    @RequestMapping("/workbench/activity/importActivityByList.do")
    public @ResponseBody Object importActivityByList(MultipartFile file,HttpSession httpSession){
        //用户在view上传文件
        //1.根据用户上传的文件，在服务器上写入一份文件
        System.out.println("导入执行中");
        ReturnObject returnObject = new ReturnObject();
        try{
        User user=(User) httpSession.getAttribute(Contants.SESSION_USER);
       // File file1 = new File("D:/file/",file.getOriginalFilename());
       // file.transferTo(file1);//将file写入到D盘的file文件夹下
        InputStream inputStream = file.getInputStream();

         //2.解析D:/file/的excel文件
       // FileInputStream fileInputStream = new FileInputStream("D:/file/"+file.getOriginalFilename());
        //将excel文件里的数据 读取到workbook中
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook(inputStream);
        //获取第一页
        HSSFSheet sheetAt = hssfWorkbook.getSheetAt(0);
        //获取每行
        HSSFRow row =null;
        List<Activity> activityList = new ArrayList<>();

        for (int i = 1; i <=sheetAt.getLastRowNum(); i++) {//为最后下标
            row = sheetAt.getRow(i);
            //获取每一列
            HSSFCell cell=null;
            Activity activity=new Activity();
            activity.setId(UUIDUtils.getUUID());
            activity.setOwner(user.getId());
            activity.setCreateBy(user.getId());
            activity.setCreateTime(DateUtils.formateDateTime(new Date()));
            for (int j = 0; j < row.getLastCellNum(); j++) {//为最后下标+1
//                cell=row.getCell(j);
//                String cellValueForStr = HSSFUtils.getCellValueForStr(cell);
//                System.out.print(cellValueForStr);
                cell=row.getCell(j);
                String cellValueForStr = HSSFUtils.getCellValueForStr(cell);
                if(j==0){
                    activity.setName(cellValueForStr);
                }else if(j==1){
                    activity.setStartDate(cellValueForStr);
                }else if(j==2){
                    activity.setEndDate(cellValueForStr);
                }else if(j==3){
                    activity.setCost(cellValueForStr);
                }else if(j==4){
                    activity.setDescription(cellValueForStr);
                }

            }
           activityList.add(activity);
        }
            System.out.println(activityList);
            int i = activityService.saveCreateActivityByList(activityList);
            returnObject.setCode("1");
            returnObject.setRetData(i);
            returnObject.setMessage("你插入了"+i+"条记录");
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode("0");
            returnObject.setMessage("系统忙。。");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String activityId,HttpServletRequest httpServletRequest){
        System.out.println("执行中");
        //查询到
        Activity activity = activityService.queryActivityForDetailById(activityId);
        List<ActivityRemark> activityRemarks = activityRemarkService.queryActivityRemarkForDetailByActivityId(activityId);
        //把数据封装到request作用域中
        httpServletRequest.setAttribute("activity",activity);
      //  System.out.println(activity);
        httpServletRequest.setAttribute("activityRemarks",activityRemarks);
      //  System.out.println(activityRemarks);
        return "workbench/activity/detail";
    }
}
