<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>" >
    <title>Title</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function(){
            //给下载按钮添加单击事件
            $("#fileDownLoadBtn").click(function () {
                //发送文件下载的请求 --只能发同步请求（下载列表）
                window.location.href="workbench/activity/fileDownLoad.do";
            });
        });
    </script>
</head>
<body>
<input type="button" value="下载文件" id="fileDownLoadBtn">
</body>
</html>
