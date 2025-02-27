import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 导入 image_picker
import 'package:statistics_app/model/record_model.dart';
import 'package:statistics_app/model/user_model.dart';
import 'package:statistics_app/pages/time_off_record.dart';
import 'package:intl/intl.dart';
import 'package:statistics_app/provider/theme_provider.dart';
import 'package:statistics_app/utils/db/image_manager.dart';
import 'package:statistics_app/utils/db/record_manager.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';

import '../model/image_model.dart';
import '../utils/db/user_manager.dart';

class AddTimeOffRecordPage extends StatefulWidget {
  final Function(RecordModel) onSave;

  AddTimeOffRecordPage({required this.onSave});

  @override
  _AddTimeOffRecordPageState createState() => _AddTimeOffRecordPageState();
}

class _AddTimeOffRecordPageState extends State<AddTimeOffRecordPage> {
  DateTime? startTime;
  DateTime? endTime;
  String remark = '';
  File? photoFile; // 存储照片文件
  String totalDurationInput = ''; // 用于手动输入总时长
  final ImagePicker _picker = ImagePicker();
  final TextEditingController totalDurationController = TextEditingController();

  // 可选的员工列表
  late List<UserModel> employeeList = [];
  UserModel? _selectedEmployee;
  RecordType _type =  RecordType.timeOff;

  // 格式化 DateTime
  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  // 选择日期+时间（精确到秒）
  Future<DateTime?> _pickDateTime(BuildContext context, DateTime? initialDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return null;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialDate != null
          ? TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    String? secondStr = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(text: "0");
        return AlertDialog(
          title: Text('选择秒数'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: '秒'),
            maxLength: 2,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('确认'),
            ),
          ],
        );
      },
    );

    int second = int.tryParse(secondStr ?? '0') ?? 0;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
      second,
    );
  }

  // 选择开始时间
  void _pickStartTime() async {
    DateTime? picked = await _pickDateTime(context, startTime);
    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  // 选择结束时间
  void _pickEndTime() async {
    DateTime? picked = await _pickDateTime(context, endTime);
    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  // 选择照片
  Future<void> _pickPhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      // final bytes = await File(image.path).readAsBytes();
      final name = ImageManager.uploadImage(File(image.path));
      print("上传图片 - $name");

      setState(() {
        photoFile = File(image.path);
      });
    }
  }

  // 选择照片方式（相机或相册）
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('拍照'),
            onTap: () {
              Navigator.pop(context);
              _pickPhoto(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('从相册选择'),
            onTap: () {
              Navigator.pop(context);
              _pickPhoto(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  // 保存调休记录
  Future<void> _saveRecord() async {
    if (_selectedEmployee == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请选择员工')));
      return;
    }

    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请先选择完整的开始和结束时间')));
      return;
    }

    if (startTime!.isAfter(endTime!)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('结束时间不能早于开始时间')));
      return;
    }

    // 获取输入的总时长
    String inputDuration = totalDurationController.text.trim();
    double time = 0;
    try {
      time = double.parse(inputDuration);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请输入正确的总时长')));
      return;
    }
    if (_type == RecordType.timeOff) {
      time = 0 - time;
    }

    if (photoFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('请选择照片')));
      return;
    }
    final imagePath = await ImageManager.uploadImage(photoFile!);
    if (imagePath == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('上传图片失败')));
      return;
    }
    RecordModel? model = await RecordManager.addRecord(time: time, userId: _selectedEmployee!.id, imagePath: imagePath, startTime: DateFormat('yyyy-MM-dd HH:mm').format(startTime!), endTime: DateFormat('yyyy-MM-dd HH:mm').format(endTime!), remarks: remark);
    if (model == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('添加记录失败')));
      return;
    }
    // RecordModel model = RecordModel(time: time, userId: _selectedEmployee!.id, imageId: imageId, startTime: DateFormat('yyyy-MM-dd HH:mm').format(startTime!), endTime: DateFormat('yyyy-MM-dd HH:mm').format(endTime!));
    // await RecordManager.addNewRecord(model);
    widget.onSave(model);
    Navigator.pop(context);
  }

  _loadUser() async {
    employeeList = await UserManager.getUserList();
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _loadUser();
  }


  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Scaffold(
      appBar: AppBar(title: Text('添加调休记录')),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        if (_type == RecordType.waitTimeOff) Icon(Icons.circle_outlined, color: theme.grey,),
                        if (_type == RecordType.timeOff) Icon(Icons.check_circle_outline_rounded, color: theme.primaryColor,),
                        SizedBox(width: 4),
                        Text('调休(扣除时间)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ).addPadding(EdgeInsets.symmetric(vertical: 10)).onTap((){
                      setState(() {
                        _type = RecordType.timeOff;
                      });
                    }),
                    SizedBox(width: 40),
                    Row(
                      children: [
                        if (_type == RecordType.timeOff) Icon(Icons.circle_outlined, color: theme.grey,),
                        if (_type == RecordType.waitTimeOff) Icon(Icons.check_circle_outline_rounded, color: theme.primaryColor,),
                        SizedBox(width: 4),
                        Text('待调休(增加时间)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ).addPadding(EdgeInsets.symmetric(vertical: 10)).onTap((){
                      setState(() {
                        _type = RecordType.waitTimeOff;
                      });
                    }),
                  ]
                ),
                SizedBox(height: 16,),

                // 选择员工
                Text('选择员工'),
                DropdownButton<UserModel>(
                  value: _selectedEmployee,
                  hint: Text('请选择员工'),
                  isExpanded: true,
                  items: employeeList.map((UserModel user) {
                    return DropdownMenuItem<UserModel>(
                      value: user,
                      child: Text('${user.name}(${user.positions})'),
                    );
                  }).toList(),
                  onChanged: (UserModel? newValue) {
                    setState(() {
                      _selectedEmployee = newValue;
                    });
                  },
                ),
                SizedBox(height: 16),
                Text('开始时间: ${startTime != null ? formatDateTime(startTime!) : "未选择"}').addPadding(EdgeInsets.symmetric(vertical: 10)).onTap(_pickStartTime),
                SizedBox(height: 16),

                Text(
                    '结束时间: ${endTime != null ? formatDateTime(endTime!) : "未选择"}').addPadding(EdgeInsets.symmetric(vertical: 10)).onTap(_pickEndTime),
                SizedBox(height: 16),

                // 手动输入总时长
                TextField(
                  controller: totalDurationController,
                  decoration: InputDecoration(
                    labelText: '总计时长（小时）',
                    hintText: '',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  onChanged: (value) {
                    setState(() {
                      totalDurationInput = value;
                    });
                  },
                ),
                SizedBox(height: 16),

                TextField(
                  decoration: InputDecoration(labelText: '备注'),
                  onChanged: (value) => setState(() {
                    remark = value;
                  }),
                ),
                SizedBox(height: 16),

                GestureDetector(
                  onTap: _showPhotoOptions,
                  child: photoFile == null
                      ? Container(
                          color: Colors.grey[200],
                          height: 100,
                          width: double.infinity,
                          child: Center(child: Text('点击上传照片')),
                        )
                      : Image.file(photoFile!),
                ),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _saveRecord,
                  child: Text('保存记录'),
                ),
              ],
            ),
          )),
    );
  }
}


enum RecordType {
  // 调休
  timeOff,
  // 待调休
  waitTimeOff,
}