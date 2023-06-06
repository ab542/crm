<%--
  Created by IntelliJ IDEA.
  User: 31493
  Date: 2023/4/14
  Time: 14:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <!--  JQUERY -->
  <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

  <!--  BOOTSTRAP -->
  <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
  <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

  <!--  PAGINATION plugin -->
  <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
  <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
  <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <title>Title</title>
  <script type="text/javascript">
    $(function() {

      $("#demo_pag1").bs_pagination({
        totalPages: 100
      });

    });
  </script>
</head>
<body>
<!--  Just create a div and give it an ID -->

<div id="demo_pag1"></div>
</body>
</html>
