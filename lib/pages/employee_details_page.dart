

import 'package:flutter/material.dart';
import 'package:statistics_app/model/record_model.dart';
import 'package:statistics_app/pages/time_off_detail_page.dart';
import 'package:statistics_app/utils/db/record_manager.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';
import 'package:statistics_app/widget/my_app_bar.dart';

import '../model/show_record_model.dart';
import '../model/user_model.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final UserModel employee;
  const EmployeeDetailsPage({super.key, required this.employee});

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {

  List<RecordModel> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '员工详情',),
      body: ListView(
        children: [
          const SizedBox(height: 16,),
          Text('${widget.employee.time >= 0 ? "+" : ""}${widget.employee.time}小时',
            style: TextStyle(
              fontSize: 24,
              color:
              widget.employee.time >= 0 ? Colors.green : Colors.red,
            ),
          ).center(),
          SizedBox(height: 16,),
          Text("姓名: ${widget.employee.name}", style: TextStyle(fontSize: 16),).margin(EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 16,),
          Text("职位: ${widget.employee.positions}", style: TextStyle(fontSize: 16),).margin(EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 16,),
          Text("调休记录: ", style: TextStyle(fontSize: 16),).margin(EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 16,),
          ...records.map((e){
            return _recordItem(e);
          }),
        ],
      ),
    );
  }


  void _loadRecords() async {
    records = await RecordManager.getAllRecords(userId: widget.employee.id);
    setState(() {});
  }

  Widget _recordItem(RecordModel record) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // 设置背景颜色
        borderRadius: BorderRadius.circular(10), // 圆角
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 阴影颜色
            blurRadius: 8, // 阴影模糊程度
            offset: Offset(0, 4), // 阴影偏移
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 容器外边距
      child: ListTile(
        title: Text(widget.employee.name ?? ''),
        subtitle: Column(
          children: [
            Text(
                '开始时间: ${record.startTime}'
            ),
            Text(
                '结束时间: ${record.endTime}'
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              record.time >= 0
                  ? '+${record.time}小时'
                  : '${record.time}小时',
              style: TextStyle(
                fontSize: 16,
                color:
                record.time >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        onTap: () => _viewDetails(ShowRecordModel(recordModel: record, userModel: widget.employee)),
      ),
    );
  }


  void _viewDetails(ShowRecordModel record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeOffDetailPage(record: record),
      ),
    );
  }

}
