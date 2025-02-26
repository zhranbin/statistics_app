import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  List<Employee> employees = [
    Employee(name: '张三', position: '经理', hoursOff: 10),
    Employee(name: '李四', position: '开发', hoursOff: -5),
  ];

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
                  setState(() {
                    employees.add(Employee(name: name, position: position));
                  });
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

  void _editEmployee(Employee employee) {
    String name = employee.name;
    String position = employee.position;
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController positionController =
        TextEditingController(text: position);

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
              onPressed: () {
                setState(() {
                  employee.name = name;
                  employee.position = position;
                });
                Navigator.pop(context);
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }

  void _viewDetails(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailsPage(employee: employee),
      ),
    );
  }

  // void _deleteEmployee(int index) {
  //   setState(() {
  //     employees.removeAt(index);
  //   });
  // }

  _deleteEmployee(BuildContext context, int index) {
    // 这个函数在触发时什么都不做。
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     employees.removeAt(index);
    //   });
    // });
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
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return Slidable(
              // Specify a key if the Slidable is dismissible.
              // key: const ValueKey(0),
              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: _deleteEmployee(context, index),
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  )
                ],
              ),

              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: ListTile(
                title: Text(
                  employee.name,
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  employee.position,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      employee.hoursOff >= 0
                          ? '+${employee.hoursOff}小时'
                          : '${employee.hoursOff}小时',
                      style: TextStyle(
                        fontSize: 24,
                        color:
                            employee.hoursOff >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                onLongPress: () => _editEmployee(employee),
              ),
            );
          }),
      // body: ListView.builder(
      //   itemCount: employees.length,
      //   itemBuilder: (context, index) {
      //     final employee = employees[index];
      //     return Dismissible(
      //       key: Key(employee.name),
      //       direction: DismissDirection.endToStart,
      //       onDismissed: (direction) {
      //         // 在这里不直接删除，改为显示删除按钮
      //       },
      //       background: Container(
      //         color: Colors.red,
      //         alignment: Alignment.centerRight,
      //         padding: EdgeInsets.symmetric(horizontal: 20),
      //         child: Icon(Icons.delete, color: Colors.white),
      //       ),
      //       child: ListTile(
      //         title: Text(
      //           employee.name,
      //           style: TextStyle(fontSize: 16),
      //         ),
      //         subtitle: Text(
      //           employee.position,
      //           style: TextStyle(fontSize: 14),
      //         ),
      //         trailing: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text(
      //               employee.hoursOff >= 0
      //                   ? '+${employee.hoursOff}小时'
      //                   : '${employee.hoursOff}小时',
      //               style: TextStyle(
      //                 fontSize: 24,
      //                 color: employee.hoursOff >= 0 ? Colors.green : Colors.red,
      //               ),
      //             ),
      //           ],
      //         ),
      //         onTap: () => _viewDetails(employee),
      //         onLongPress: () => _editEmployee(employee),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

class EmployeeDetailsPage extends StatelessWidget {
  final Employee employee;

  EmployeeDetailsPage({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${employee.name} 的详情')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('员工名称: ${employee.name}', style: TextStyle(fontSize: 18)),
            Text('职位: ${employee.position}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('调休记录:', style: TextStyle(fontSize: 18)),
            // 这里可以显示员工的调休记录，暂时用示例代替
            Text('没有调休记录', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
