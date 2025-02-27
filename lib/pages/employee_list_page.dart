import 'package:flutter/material.dart';
import 'package:statistics_app/model/user_model.dart';
import 'package:statistics_app/utils/db/user_manager.dart';

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
                return isDelete == true;
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


}

