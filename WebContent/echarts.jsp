<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>echarts</title>
<script src="static/js/echarts.min.js"></script>
<script src="static/js/jquery-1.11.1.min.js"></script>

</head>
<body>

	<br />
	<%
		// 配置 configuations

		//excel的路径
		//1.excel必须是xls结尾，否则没法识别
		//2.文件内容必须在第一个sheet
		String fileName = "C:\\Users\\junfeng\\eclipse-workspace\\Echarts\\WebContent\\WEB-INF\\data\\data.xls";
		String colSeperator = "`";//列分隔符
		String rowSeperator = "^";//行分隔符
		//out.println("你的 IP 地址 " + request.getRemoteAddr());
	%>

	<br />
	<%@page import="jxl.*,java.io.*,java.text.*"%>

	<%
		// this is just read the data.xls，然后转换为Html保存在页面里面
		Workbook workbook = null;
		Sheet sheet = null;
		Cell cell = null;
		try {
			workbook = Workbook.getWorkbook(new File(fileName));
		} catch (Exception e) {
			out.println("无法打开excel；excel必须是xls结尾，否则没法识别！ " + e);
			return;
		}

		try {
			sheet = workbook.getSheet(0);//打开第一个sheet页，文件也必须在第一个sheet
		} catch (Exception e) {
			out.println("打开第一个sheet页，文件也必须在第一个sheet;" + e);
			return;
		}
		int columnCount = sheet.getColumns();
		int rowCount = sheet.getRows();
		out.println("rows:" + rowCount + " cols:" + columnCount);// just for test
		StringBuilder content = new StringBuilder();
		for (int i = 0; i < rowCount; i++) {
			for (int j = 0; j < columnCount; j++) {
				cell = sheet.getCell(j, i);
				if (cell.getType() == CellType.DATE) {
					String tTime = new SimpleDateFormat("yyyy-MM-dd").format(((DateCell) cell).getDate());
					content.append(tTime + colSeperator);
				} else {
					content.append(cell.getContents() + colSeperator);
				}
			}
			content.append(rowSeperator);
		}
		workbook.close();
		out.println("<input id='fileConent' type='hidden' value=" + content.toString() + ">");
	%>

	<div id="container"
		style="height: 800px; width: 1200px; background: white; margin: 20px 0 0;"></div>

	<script>
		//var fileContentStr = $("#fileConent").val();
		var fileContentArr = $("#fileConent").val().split("^");//行分隔符
		var arr=[];//二维数据
		for(i=0;i< fileContentArr.length;i++) {
			arr[i] = fileContentArr[i].split("`");//列分隔符
		}
		option = {
    legend: {},
    tooltip: {},
    dataset: {
        // 提供一份数据。
        source: arr
    },
    // 声明一个 X 轴，类目轴（category）。默认情况下，类目轴对应到 dataset 第一列。
    xAxis: {type: 'category'},
    // 声明一个 Y 轴，数值轴。
    yAxis: {},
    // 声明多个 bar 系列，默认情况下，每个系列会自动对应到 dataset 的每一列。
    series: [
        {type: 'bar'},
        {type: 'bar'},
        {type: 'bar'}
    ]
}

		//初始化echarts实例
		var myChart = echarts.init(document.getElementById('container'));
		//使用制定的配置项和数据显示图表
		myChart.setOption(option);
	</script>
</body>
</html>