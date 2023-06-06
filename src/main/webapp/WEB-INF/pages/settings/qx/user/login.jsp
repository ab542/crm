<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core_1_1" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
	Cookie[] cookies = request.getCookies();
	for (Cookie cookie : cookies) {
		if("loginAct".equals(cookie.getName())){
			String loginAct=cookie.getValue();
		}else if("loginPwd".equals(cookie.getName())){
			String loginPwd=cookie.getValue();
		}
	}
%>


<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		// 当整个页面加载完，会自动调用这个函数
		$(function () {
			//给整个浏览器窗口添加键盘按下事件
			$(window).keydown(function (event) {
				//如果按的是回车键 则提交登录请求
				//event 表示正在发生的事件
				//alert(event.keyCode);//每个按键都有特定的编码
				if(event.keyCode==13){
					//发送请求（按回车键）
					$("#loginBtn").click();//在指定的元素上模拟发生一次事件
				}
			})
			//给登录按钮 绑定单击事件
			$("#loginBtn").click(function () {
				//发请求，执行指令
				//收集参数
				 var loginAct = $.trim($("#loginAct").val());//有空格 需要去掉空格
				 var loginPwd = $.trim($("#loginPwd").val());
				 var isRemPwd = $("#isRemPwd").prop("checked");

				//发送请求
				//url前面不用加/ 因为前面定义了一个base，自动填充
				//data里的数据名 必须与controller形参里的参数名 保持一致
				//dataType:返回响应信息的类型json
				//success处理响应
				$.ajax({
					url:'settings/qx/user/login.do',
					data:{
						loginAct:loginAct,
						loginPwd:loginPwd,
						isRemPwd:isRemPwd
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.code=="1"){//说明登录成功
							//跳转业务主页面(同步请求 1.form表单 2.地址栏 3.超级链接)
							//通过地址栏，且因为在web-inf下 必须经过contrioller
							window.location.href="workbench/index.do"
						}else{
							//登录失败 html可以写标签或者提示信息，text只能写提示信息
							$("#msg").html(data.message);
						}
					},
					beforeSend:function (){
						//该函数返回值能够决定ajax是否真正向后台发送请求 如果为true，则ajax会真正向后台发送请求，如果为false，放弃发请求
						//表单验证
						if(loginAct==""){
							alert("用户名不能为空")
							return false;
						}
						if(loginPwd==""){
							alert("密码不能为空")
							return false;
						}
						$("#msg").html("正在登录中");
						return true;
					}
				})

			});
		})
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2023&nbsp;李盈开发的CRM系统</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" class="form-control" value="${cookie.loginAct.value}" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" class="form-control" value="${cookie.loginPwd.value}" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
								<input id="isRemPwd" type="checkbox" checked="checked">
							</c:if>
							<c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
								<input id="isRemPwd" type="checkbox">
							</c:if>
							十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
<%--					这里如果type是submit 说明是同步请求  表示登录失败 整个页面发生改变，如果需要局部变化 需要使用ajax
                       方式一：    onclick="test()"
                           --%>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>