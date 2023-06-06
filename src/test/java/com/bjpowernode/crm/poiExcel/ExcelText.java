package com.bjpowernode.crm.poiExcel;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 使用apache-poi生成
 * 创建excel
 */
public class ExcelText {
    public static void main(String[] args) {
        //学生列表
        HSSFWorkbook workbook = new HSSFWorkbook();//excel文件对象
        //使用wb对象创建HSSFSheet对象，对应wb文件中的一页
        HSSFSheet sheet = workbook.createSheet("学生列表");
        //创建行
        HSSFRow row = sheet.createRow(0);//从0开始逐渐递增
        //创建列
        HSSFCell cell = row.createCell(0);//从0开始逐渐递增
        cell.setCellValue("学号");
        cell = row.createCell(1);
        cell.setCellValue("姓名");
        cell = row.createCell(2);
        cell.setCellValue("年龄");

        HSSFCellStyle hssfCellStyle = workbook.createCellStyle();
       // hssfCellStyle.setFillBackgroundColor();
        hssfCellStyle.setAlignment(HorizontalAlignment.CENTER);
        //保存学生信息
        for (int i = 1; i <=10; i++) {
            row= sheet.createRow(i);
            cell = row.createCell(0);//从0开始逐渐递增
            cell.setCellValue(100+i);
            cell = row.createCell(1);
            cell.setCellValue("name"+i);
            cell = row.createCell(2);
            cell.setCellStyle(hssfCellStyle);
            cell.setCellValue(20+i);
        }

        //调用工具函数生成excel
        try {
            FileOutputStream fileOutputStream = new FileOutputStream("D:\\student.xls");
            /**
             * 以下方法效率是十分低的，因为是直接往磁盘里写入数据
             * 如果线程多的话，效率是十分低的，服务器要爆咋了
             */
            workbook.write(fileOutputStream);
            /**
             * 用完之后 及时关闭 资源珍贵
             */
            fileOutputStream.close();
            workbook.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("------ok-----------");


    }
}
