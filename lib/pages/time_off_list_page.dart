import 'package:flutter/material.dart';
import 'package:statistics_app/pages/add_time_off_record_page.dart';
import 'package:statistics_app/pages/time_off_detail_page.dart';
import 'package:statistics_app/pages/time_off_record.dart';
import 'package:intl/intl.dart'; // 引入 intl 格式化时间

class TimeOffListPage extends StatefulWidget {
  @override
  _TimeOffListPageState createState() => _TimeOffListPageState();
}

class _TimeOffListPageState extends State<TimeOffListPage> {
  // 格式化时间，去掉毫秒
  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  List<TimeOffRecord> records = [
    TimeOffRecord(
      employeeName: '张三',
      startTime: DateTime(2025, 2, 20, 9, 0),
      endTime: DateTime(2025, 2, 20, 17, 0),
      totalDuration: Duration(hours: 8),
      remark: '生病请假',
      photoUrl: 'https://example.com/photo1.jpg',
    ),
    TimeOffRecord(
      employeeName: '李四',
      startTime: DateTime(2025, 2, 18, 10, 0),
      endTime: DateTime(2025, 2, 18, 14, 0),
      totalDuration: Duration(hours: 4),
      remark: '家庭原因',
    ),
  ];

  List<TimeOffRecord> filteredRecords = [];
  String selectedEmployee = '所有员工';

  @override
  void initState() {
    super.initState();
    filteredRecords = records;
  }

  void _filterRecords(String employeeName) {
    setState(() {
      selectedEmployee = employeeName;
      if (employeeName == '所有员工') {
        filteredRecords = records;
      } else {
        filteredRecords = records
            .where((record) => record.employeeName == employeeName)
            .toList();
      }
    });
  }

  void _viewDetails(TimeOffRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeOffDetailPage(record: record),
      ),
    );
  }

  void _addRecord() {
    // 这里可以通过弹窗或跳转到新增记录页面
    // 比如，展示一个表单用于填写新的调休记录
    // print("点击了添加记录按钮");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTimeOffRecordPage(
          onSave: (newRecord) {
            setState(() {
              records.add(newRecord); // 保存新记录到列表
              filteredRecords = records; // 更新筛选后的记录
            });
            // Navigator.pop(context); // 返回上一级页面
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('调休记录'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('筛选员工'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ['所有员工', '张三', '李四'].map((employee) {
                        return ListTile(
                          title: Text(employee),
                          onTap: () {
                            _filterRecords(employee);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addRecord,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredRecords.length,
        itemBuilder: (context, index) {
          final record = filteredRecords[index];
          return ListTile(
            title: Text(record.employeeName),
            subtitle: Text(
              '调休时间: ${formatDateTime(record.startTime)} - ${formatDateTime(record.endTime)}\n'
              '时长: ${record.totalDuration.inHours}小时',
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => _viewDetails(record),
          );
        },
      ),
    );
  }
}
