package com.bjpowernode.crm.poiExcel;

import com.bjpowernode.crm.commons.utils.HSSFUtils;
import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * 解析excel里面的数据，将其封装成java对象集合
 */
public class PoseExcelToActivityJava {
    public static void main(String[] args) throws Exception {
        FileInputStream fileInputStream = new FileInputStream("D:/activityList.xls");
        //将excel文件里的数据 读取到workbook中
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook(fileInputStream);
        //获取第一页
        HSSFSheet sheetAt = hssfWorkbook.getSheetAt(0);
        //获取每行
        HSSFRow row =null;
        for (int i = 0; i <=sheetAt.getLastRowNum(); i++) {//为最后下标
           row = sheetAt.getRow(i);
           //获取每一列
            HSSFCell cell=null;
            for (int j = 0; j < row.getLastCellNum(); j++) {//为最后下标+1
                cell=row.getCell(j);
                String cellValueForStr = HSSFUtils.getCellValueForStr(cell);
                System.out.print(cellValueForStr);
            }
            System.out.println();
        }
    }
}
