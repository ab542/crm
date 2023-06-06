<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>" >
    <title>文件上传</title>
</head>
<body>
<form action="workbench/activity/upLoadFile.do" method="post" enctype="multipart/form-data">
    <input type="file" name="file">
    <input type="hidden" value="liying" name="name">
    <input type="submit" value="提交">
</form>

</body>
</html>
