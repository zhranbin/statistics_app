import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:statistics_app/model/user_model.dart';
import 'package:statistics_app/pages/setting_net_ip_page.dart';
import 'package:statistics_app/utils/db/user_manager.dart';
import 'package:statistics_app/utils/my_route.dart';

import '../provider/theme_provider.dart';
import '../utils/db/backup_manager.dart';
import 'employee_details_page.dart';

class Employee {
  String name;
  String position;
  int hoursOff;

  Employee({required this.name, required this.position, this.hoursOff = 0});
}

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<UserModel> users = [];


  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('员工列表'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () async {
              await BackupManager.backupUsers();
              await BackupManager.backupImages();
              await BackupManager.backupRecords();
            },
          ),
          IconButton(
          icon: Icon(Icons.settings),
          onPressed: () async {
            MyRoute.push(SettingNetIpPage());
          },
        ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEmployee,
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Dismissible(
              key: Key('${user.id}'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                final isDelete = await showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('删除确认'),
                    content: Text('确定要删除该员工吗？'),
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
                await UserManager.deleteUser(user.id);
                _loadUsers();
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
                  title: Text(
                    user.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    user.positions,
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.time >= 0
                            ? '+${user.time}小时'
                            : '${user.time}小时',
                        style: TextStyle(
                          fontSize: 24,
                          color:
                          user.time >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  onLongPress: () => _editUser(user),
                  onTap: () => _viewDetails(user),
                ),
              ),
            );
          }),
    );
  }


  Future<void> _loadUsers() async {
    users = await UserManager.getUserList();
    setState(() {});
  }


  void _addEmployee() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String position = '';
        return AlertDialog(
          title: Text('添加员工'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: '名称'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: '职位'),
                onChanged: (value) => position = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && position.isNotEmpty) {
                  UserModel user = UserModel(
                      name: name,
                      positions: position,
                      time: 0
                  );
                  UserManager.addUser(user);
                  _loadUsers();
                  Navigator.pop(context);
                }
              },
              child: Text('添加'),
            ),
          ],
        );
      },
    );
  }

  void _editUser(UserModel user) {
    String name = user.name;
    String position = user.positions;
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController positionController = TextEditingController(text: position);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('编辑员工'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: '名称'),
                onChanged: (value) => name = value,
              ),
              TextField(
                controller: positionController,
                decoration: InputDecoration(labelText: '职位'),
                onChanged: (value) => position = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                user.name = name;
                user.positions = position;
                await UserManager.updateUser(user);
                setState(() {});
                Navigator.pop(context);
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }

  void _viewDetails(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailsPage(employee: user),
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

