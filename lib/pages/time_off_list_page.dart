import 'package:flutter/material.dart';
import 'package:statistics_app/model/record_model.dart';
import 'package:statistics_app/model/show_record_model.dart';
import 'package:statistics_app/model/user_model.dart';
import 'package:statistics_app/pages/add_time_off_record_page.dart';
import 'package:statistics_app/pages/time_off_detail_page.dart';
import 'package:statistics_app/pages/time_off_record.dart';
import 'package:intl/intl.dart';

import '../utils/db/record_manager.dart';
import '../utils/db/user_manager.dart'; // 引入 intl 格式化时间

class TimeOffListPage extends StatefulWidget {
  @override
  _TimeOffListPageState createState() => _TimeOffListPageState();
}

class _TimeOffListPageState extends State<TimeOffListPage> {
  // 格式化时间，去掉毫秒
  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  List<ShowRecordModel> _data = [];
  List<ShowRecordModel> _allData = [];
  UserModel? _userModel;



  @override
  void initState() {
    super.initState();
    _loadAllRecords();
  }


  void _loadAllRecords() async {
    List<ShowRecordModel> d = [];
    final records = await RecordManager.getAllRecords();
    for (var record in records) {
      UserModel? user = await UserManager.getUser(record.userId);
      if (user != null) {
        d.add(ShowRecordModel(recordModel: record, userModel: user));
      }
    }
    _allData = d;
    _refreshAction();

  }

  void _refreshAction() {
    if (_userModel == null) {
      _data = _allData;
    } else {
      _data = _allData.where((record) => record.userModel!.id == _userModel!.id).toList();
    }
    setState(() {});
  }

  void _viewDetails(ShowRecordModel record) {
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
              _loadAllRecords();
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
                  List<UserModel> users = [];
                  return AlertDialog(
                    title: Text('筛选员工'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ([UserModel()] + users).map((employee) {
                        return ListTile(
                          title: Text(employee.id != 0 ? employee.name : '全部'),
                          onTap: () {
                            _userModel = employee;
                            if (employee.id == 0) {
                              _userModel = null;
                            }
                            _refreshAction();
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
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final record = _data[index];
          return ListTile(
            title: Text(record.userModel.name ?? ''),
            subtitle: Text(
              '调休时间: ${record.recordModel.startTime} - ${record.recordModel.endTime}\n'
              '时长: ${record.recordModel.time.toStringAsFixed(1)}小时',
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => _viewDetails(record),
          );
        },
      ),
    );
  }
}
