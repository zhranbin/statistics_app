import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:statistics_app/model/record_model.dart';
import 'package:statistics_app/model/show_record_model.dart';
import 'package:statistics_app/model/user_model.dart';
import 'package:statistics_app/pages/add_time_off_record_page.dart';
import 'package:statistics_app/pages/time_off_detail_page.dart';
import 'package:statistics_app/pages/time_off_record.dart';
import 'package:intl/intl.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';

import '../provider/theme_provider.dart';
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
            onPressed: () async {
              List<UserModel> users = [];
              users = await UserManager.getUserList();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('筛选员工'),
                    content: ListView(
                      // mainAxisSize: MainAxisSize.min,
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
                    ).size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - 240),
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
          return Dismissible(
            key: Key('${record.recordModel.id}'),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              final isDelete = await showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                    title: Text('删除确认'),
                    content: Text('确定要删除该记录吗？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('确定'),
                      )
                    ]
                );
              });
              if (isDelete != true) {
                return false;
              }
              final ver = await verifyPassword(context);
              return ver == true;
            },
            onDismissed: (direction) async {
              await RecordManager.deleteRecord(record.recordModel.id);
              _loadAllRecords();
            },
            child: Container(
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
                title: Text(record.userModel.name ?? ''),
                subtitle: Column(
                  children: [
                    Text(
                        '开始时间: ${record.recordModel.startTime}'
                    ),
                    Text(
                        '结束时间: ${record.recordModel.endTime}'
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      record.recordModel.time >= 0
                          ? '+${record.recordModel.time}小时'
                          : '${record.recordModel.time}小时',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                        record.recordModel.time >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                onTap: () => _viewDetails(record),
              ),
            ),
          );




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
              title: Text(record.userModel.name ?? ''),
              subtitle: Column(
                children: [
                  Text(
                      '开始时间: ${record.recordModel.startTime}'
                  ),
                  Text(
                      '结束时间: ${record.recordModel.endTime}'
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    record.recordModel.time >= 0
                        ? '+${record.recordModel.time}小时'
                        : '${record.recordModel.time}小时',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                      record.recordModel.time >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              onTap: () => _viewDetails(record),
            ),
          );
        },
      ),
    );
  }



  Future<bool> verifyPassword(BuildContext context, {MyTheme? theme}) async {
    Future<bool> _checkFingerprint() async {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      //print('是否支持指纹识别: $canAuthenticate');
      if (canAuthenticate) {
        final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
        //print('支持的指纹识别: $availableBiometrics');
        if (availableBiometrics.isNotEmpty) {
          try {
            final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate to show account balance',
              options: const AuthenticationOptions(
                biometricOnly: true,
                stickyAuth: true,
              ),
            );
            //print('是否验证成功: $didAuthenticate');
            auth.stopAuthentication();
            return didAuthenticate;
          } catch (e) {
            print(e);
            return false;
          }
        } else {
          //print('没有可用的指纹识别');
        }
      }
      {
        //print('不支持指纹识别');
        return false;
      }
    }
    final res = await _checkFingerprint();
    if (res != true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('验证失败')));
      return false;
    }
    return res; // 验证通过
  }


}
