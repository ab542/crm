<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core_1_1" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>" >
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript">

	$(function(){
		//点击创建 触发点击事件
		$("#createBtn").click(function (){
			//bug：第一次点击创建按钮 之后按保存，之后，前一次的数据会保存（只是模态窗口隐藏了，数据还在），所以还需要清空模态窗口中的内容，即在点击创建之前清空数据
			$("#createForm").get(0).reset();//重置表单.get(0)获取document对象 或【0】
			$("#createActivityModal").modal("show");//显示模态窗口
		})
		//设置日期
		$(".mydate").datetimepicker({
			language:'zh-CN',//语言
			format:'yyyy-mm-dd',
			minView:'month',//最小视图
			initialDate:new Date(),//初始化显示的日期
			autoclose:true,//设置选择完日期或者时间之后，日历是否自动关闭，默认是false
			todayBtn:true,//设置是否显示今天按钮 默认false
			clearBtn:true//设置是否显示清空按钮 默认false
		});
		//在模态窗口中 点击保存 触发点击事件
		$("#saveBtn").click(function () {
			//收集参数
			var owner =$("#create-marketActivityOwner").val();
			var name =$.trim($("#create-marketActivityName").val());
			var startDate =$("#create-startTime").val();
			var endDate =$("#create-endTime").val();
			var cost =$.trim($("#create-cost").val());
			var description =$.trim($("#create-describe").val());
             alert(startDate)
			//表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("用户不能为空");
				return;
			}
			if(startDate!=""&&endDate!=""){
			    //方式一：字符串转date比较	new Date();
		    	//方式二：使用字符串的大小来代替日期的大小
			   if(endDate<startDate){
					alert("介绍日期不能比开始日期小");
					return;
				}
			}
			//成本只能为非负整数
			//正则表达式：判断某一字段值是否合法
			/**
			 * 正则表达式：
			 *    1.语言，语法：可以定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合这种匹配模式
			 *    优先网上找 保存一份
			 *    语法通则：
			 *        1） // ：表示在js中定义一个正则表达式 var regExp=/dsdsds/;
			 *        2) [xxxx] : 匹配指定字符集中的一位字符 var regExp=/[abc]/;匹配字符串 一位中括号只能匹配一位字符 可以 a b  ab（不行）
			 *        3） ^ : 表示匹配字符串的开头位置
			 *            $ : 匹配指定字符串的结尾
			 *            var regExp=/^[0-9]$/;
			 *        4) {} ： 匹配次数 var regExp=/^[0-9]{5}$/;  五位
			 *               {m}：匹配m次
			 *               {m,n} 匹配m次到n次 都行
			 *               {m,} 匹配m次或更多次
			 *        5） 特殊符号：
			 *            \d ：匹配一位数字
			 *            \D : 匹配一位非数字
			 *            \w : 匹配所有的字符 字母 数字 下划线
			 *            \W : 匹配非字符（除上面以外）
			 *             * ：匹配0次或者多次，相当于{0,}
			 *             + :匹配1次或者多次，{1，}
			 *             ？ ：匹配0次或者1次 ，{0，1}
			 */
              var regExp=/^(([1-9]\d*)|0)$/;
              if(!regExp.test(cost)){
              	alert("成本只能为非负整数");
              	return;
			  }
              //发送请求
			 $.ajax({
				 url:'workbench/activity/saveCreateActivity.do',
				 data:{
				 	owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				 },
				 type:'post',
				 dataType:'json',
				 success:function (data) {//响应结果
					 if(data.code==1){
					 	//关闭模态窗口
						 $("#createActivityModal").modal("hide");
						 //刷新市场活动列，显示第一页数据，保持每页显示条数不变
						 queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
						 //暂时不做
					 }else{
					 	//失败：提示信息
						 alert(data.message);
						 //模态窗口
						 $("#createActivityModal").modal("show");
					 }
				 }
			 })

		})

		//需求1：一开始加载第一页
		queryActivityByConditionForPage(1,3);

		//给查询按钮加单击时间
		/*
		当用户点击”查询“按钮，查询所有符合条件数据的第一页及所有符合条件数据的总条数
		 */
		$("#queryByCondition").click(function () {
			queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
		})


		//给全选添加单击事件
          $("#checkAll").click(function () {
			 $("tbody input[type='checkbox']").prop("checked",this.checked);//将tbbody标签下的所有input的checked标签设为true
		 });
		//取消全选，如果列表中有一个没有选，就要取消全选按钮
		/**
		 * 在使用下面代码 实现以上功能的时候，出现了无反应情况，因为在执行以下代码的时候，js代码还没加载不到tbody input[type='checkbox']
		 * 因为tbody input[type='checkbox'】为动态生成的标签，不是固有的，且是ajax请求发送过来的，在发送ajax请求的时候，js代码会往下进行，不会等ajax请求响应，所以在执行
		 * 到以下代码的时候还为生成tbody input[type='checkbox']标签
		 * 后台请求速度比前端js代码执行慢
		 */
		// $("tbody input[type='checkbox']").click(function () {
		// 	if($("tbody input[type='checkbox']").size()==$("tbody input[type='checkbox']:checked").size()){//如果相等说明全选了
		// 		$("#checkAll").prop("checked",true);//给全选按钮设为选中
		// 	}else{
		// 		$("#checkAll").prop("checked",false);
		// 	}
		// });
		$("tbody").on("click","input[type='checkbox']",function () {
			if($("tbody input[type='checkbox']").size()==$("tbody input[type='checkbox']:checked").size()){//如果相等说明全选了
						$("#checkAll").prop("checked",true);//给全选按钮设为选中
				 	}else{
				    	$("#checkAll").prop("checked",false);
				 	}
		});

		//给删除按钮添加点击事件
		$("#removeActivityBtn").click(function () {
			//首先需要获取到需要删除的ids
			if($("tbody input[type='checkbox']:checked").size()==0){//说明没有选中删除的
				alert("请选择需要删除的市场活动");
				return;//直接退出
			}
			//说明选中了，就要获取到ids
			var items = $("tbody input[type='checkbox']:checked");
			var ids="";
			$.each(items,function (index,obj) {
				ids+="id="+this.value+"&";
			});
			ids=ids.substr(0,ids.length-1);
			alert(ids);
			if(window.confirm("确定删除吗？")) {
				//获取到所有ids后 异步请求发送
				$.ajax({
					url: 'workbench/activity/removeActivityByIds.do',
					data: ids,
					type: 'post',
					dataType: 'json',
					success: function (data) {
						if (data.code == 1) {//删除成功
							queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(data.message);
						}
					}
				});
			}

		});

		//给修改按钮添加事件
		$("#editActivityBtn").click(function () {
			alert("修改");
			//显示选中的市场活动的所有信息
			if($("tbody input[type='checkbox']:checked").size()==0){
				alert("未选中需要修改的市场活动");
				return;
			}
			if($("tbody input[type='checkbox']:checked").size()>1){
				alert("要求只能选中一个");
				return;
			}
			var id = $("tbody input[type='checkbox']:checked").get(0).value;
			alert("发送请求");
			$.ajax({
				url:'workbench/activity/queryActivityById.do',
				data:{
					id:id
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					alert("响应中");
					$("#edit_id").val(data.id);
					$("#edit-marketActivityOwner").val(data.owner);
					$("#edit-marketActivityName").val(data.name);
					$("#edit-startTime").val(data.startDate);
					$("#edit-endTime").val(data.endDate);
					$("#edit-cost").val(data.cost);
					$("#edit-describe").val(data.description);

					$("#editActivityModal").modal("show");
				}
			});


		});

		//给更新按钮加事件
		$("#updateBtn").click(function () {

			//收集参数
			var id = $("#edit_id").val();
			var owner=$.trim($("#edit-marketActivityOwner").val());
			var name=$.trim($("#edit-marketActivityName").val());
			var startDate=$("#edit-startTime").val();
			var endDate=$("#edit-endTime").val();
			var cost=$.trim($("#edit-cost").val());
			var description=$.trim($("#edit-describe").val());

			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("用户不能为空");
				return;
			}
			if(startDate!=""&&endDate!=""){
				//方式一：字符串转date比较	new Date();
				//方式二：使用字符串的大小来代替日期的大小
				if(endDate<startDate){
					alert("介绍日期不能比开始日期小");
					return;
				}
			}
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能为非负整数");
				return;
			}
			alert("更新中");
			//发送请求
			$.ajax({
				url:'workbench/activity/updateActivityById.do',
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:'post',
				dataType:'json',
				success:function (data) {//响应结果
					alert("更新响应");
					if(data.code==1){
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
						//刷新市场活动列，显示第一页数据，保持每页显示条数不变
						queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption','currentPage'),$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
						//暂时不做
					}else{
						//失败：提示信息
						alert(data.message);
						//模态窗口
						$("#editActivityModal").modal("show");
					}
				}
			})
		});

		//给批量导出添加点击事件
		$("#exportActivityAllBtn").click(function (){
			window.location.href='workbench/activity/outportAllActivities.do';
		});

		//给批量的导入的 提交按钮添加点击事件
		$("#importActivityBtn").click(function () {
			//获取参数
			var fileName=$("#activityFile").val();//获取的是文件名
			alert(fileName);
			var ho=fileName.substr(fileName.lastIndexOf(".")+1).toLocaleLowerCase();
			if(ho!="xls"){
				alert("只能是xls的文件")
				return;
			}
			var file=$("#activityFile")[0].files[0];
			if(file.size>5*1024*1024){
				alert("文件大小不能超过5M");
				return;
			}
			//FormData是ajax提供的接口，可以模拟键值对向后台提交参数
			//FormData最大的优势是不但能提交文本数据，还能提交二进制数据
			var formData = new FormData();
			formData.append("file",file);
			//利用ajax向后端发送post请求
			$.ajax({
				url:'workbench/activity/importActivityByList.do',
				data:formData,
				processData:false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true 是 false 否 默认true
				contentType:false,////设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：ture 默认
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//提示成功导入记录条数
						alert("成功导入"+data.retData+"条记录");
						//关闭模态窗口
						$("#importActivityModal").modal("hide");
						//刷新市场活动列表，显示第一页数据，保持每页显示条数不变
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));

					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#importActivityModal").modal("show");
					}
				}
			});
		});

	});

	function queryActivityByConditionForPage(pageNo,pageSize) {
		//收集参数
		var name =$.trim($("#query-name").val());
		var owner =$.trim($("#query-owner").val());
		var startDate =$.trim($("#query-startDate").val());
		var endDate =$.trim($("#query-endDate").val());
		//分页ajax请求
		alert(pageNo);
		$.ajax({
			url:'workbench/activity/queryActivityByConditionForPage.do',
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'post',
			dataType: 'json',
			success:function (data) {
				alert("1");
				//显示总条数
				//$("#totalRows").text(data.totalRows)
				//显示活动列表
				var htmlStr="";
				alert(data.activityList)
				$.each(data.activityList,function (index,obj) {
					htmlStr+="<tr class=\"active\">"
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"></td>"
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?activityId="+obj.id+"';\">"+obj.name+"</a></td>"
					htmlStr+="<td>"+obj.owner+"</td>"
					htmlStr+="<td>"+obj.startDate+"</td>"
					htmlStr+="<td>"+obj.endDate+"</td>"
					htmlStr+="</tr>"

					$("#activityQueryShow").html(htmlStr);
					$("#checkAll").prop("checked",false);
					//计算总页数
					var totalPages=1;
					if(data.totalRows%pageSize==0){
						totalPages=data.totalRows/pageSize;
					}else{
						totalPages=parseInt(data.totalRows/pageSize)+1;//parseInt 获取到一个小数的整数部分
						//parseInt为js的系统函数
						//eval()
						//var str="var a=100;"
						//eval(str);//把上面的代码模拟执行，为定义一个变量
					}
					//调用bs_pagination工具函数
					$("#demo_pag1").bs_pagination({
						currentPage:pageNo,

						rowsPerPage:pageSize,
						totalRows:data.totalRows,
						totalPages: totalPages,

						visiblePageLinks: 5,

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,

						onChangePage:function (event,pageObj) {
							queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);

						}

					});
				})
			}
		})

	}
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
									<c:forEach items="${requestScope.userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startTime" readonly="readonly">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input  type="text" class="form-control mydate" id="create-endTime" readonly="readonly">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" class="btn btn-primary" >保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit_id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${requestScope.userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text"  id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryByCondition">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="removeActivityBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityQueryShow">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
				<!--页码-->
				<div id="demo_pag1"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows">50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>

		</div>
		
	</div>
</body>
</html>