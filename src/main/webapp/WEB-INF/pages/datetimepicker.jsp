<%--
  Created by IntelliJ IDEA.
  User: 31493
  Date: 2023/4/12
  Time: 18:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>" >
    <meta charset="UTF-8">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.cs">
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <%--必须在容器加载完之后 才能调--%>
    <script type="text/javascript">
        //当整个页面加载完才调
       $(function () {
           $("#myDate").datetimepicker({
               language:'zh-CN',//语言
               format:'yyyy-mm-dd',
               minView:'month',//最小视图
               initialDate:new Date(),//初始化显示的日期
               autoclose:true//设置选择完日期或者时间之后，日历是否自动关闭，默认是false

           });
       })
    </script>

    <title>演示日历插件</title>
</head>
<body>
<input type="text" id="myDate">
<%--&lt;%&ndash;必须在容器加载完之后 才能调&ndash;%&gt;--%>
<%--<script type="text/javascript">--%>
<%--    --%>
<%--</script>--%>
</body>
</html>
