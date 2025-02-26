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
    // 这里是示例记录，实际数据会在运行时通过 _addRecord 方法添加
    // TimeOffRecord(
    //   employeeName: '张三',
    //   startTime: DateTime(2025, 2, 20, 9, 0),
    //   endTime: DateTime(2025, 2, 20, 17, 0),
    //   totalDuration: Duration(hours: 8),
    //   remark: '生病请假',
    //   photoUrl: 'https://example.com/photo1.jpg',
    // ),
    // TimeOffRecord(
    //   employeeName: '李四',
    //   startTime: DateTime(2025, 2, 18, 10, 0),
    //   endTime: DateTime(2025, 2, 18, 14, 0),
    //   totalDuration: Duration(hours: 4),
    //   remark: '家庭原因',
    // ),
  ];

  List<TimeOffRecord> filteredRecords = [];
  String selectedEmployee = '所有员工';

  @override
  void initState() {
    super.initState();
    // 初始化时反序排列记录
    filteredRecords = records.reversed.toList();
  }

  void _filterRecords(String employeeName) {
    setState(() {
      selectedEmployee = employeeName;
      if (employeeName == '所有员工') {
        filteredRecords = records.reversed.toList(); // 反序排列所有员工记录
      } else {
        filteredRecords = records
            .where((record) => record.employeeName == employeeName)
            .toList()
            .reversed
            .toList(); // 反序排列特定员工记录
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTimeOffRecordPage(
          onSave: (newRecord) {
            setState(() {
              records.add(newRecord); // 保存新记录到列表
              filteredRecords = records.reversed.toList(); // 更新筛选后的记录并反序
            });
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
