import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 导入 image_picker
import 'package:statistics_app/pages/time_off_record.dart';
import 'package:intl/intl.dart';

class AddTimeOffRecordPage extends StatefulWidget {
  final Function(TimeOffRecord) onSave;

  AddTimeOffRecordPage({required this.onSave});

  @override
  _AddTimeOffRecordPageState createState() => _AddTimeOffRecordPageState();
}

class _AddTimeOffRecordPageState extends State<AddTimeOffRecordPage> {
  DateTime? startTime;
  DateTime? endTime;
  String remark = '';
  File? photoFile; // 存储照片文件
  String? employeeName; // 选中的员工姓名
  String totalDurationInput = ''; // 用于手动输入总时长
  final ImagePicker _picker = ImagePicker();
  final TextEditingController totalDurationController = TextEditingController();

  // 可选的员工列表
  final List<String> employeeList = ['张三', '李四', '王五'];

  // 格式化 DateTime
  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  // 选择日期+时间（精确到秒）
  Future<DateTime?> _pickDateTime(
      BuildContext context, DateTime? initialDate) async {
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
          ? TimeOfDay.fromDateTime(initialDate)
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
  void _saveRecord() {
    if (employeeName == null) {
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
    List<String> timeParts = inputDuration.split(':');

    // 检查格式是否正确
    if (timeParts.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('总时长格式不正确，请按照 “小时:分钟” 格式输入')),
      );
      return;
    }

    // 解析小时和分钟
    int hours = int.tryParse(timeParts[0]) ?? -1;
    int minutes = int.tryParse(timeParts[1]) ?? -1;

    // 验证小时和分钟是否合法
    if (hours < 0 || minutes < 0 || minutes >= 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请输入有效的总时长 (小时:分钟)')),
      );
      return;
    }

    Duration totalDuration = Duration(hours: hours, minutes: minutes);

    // 创建记录
    TimeOffRecord newRecord = TimeOffRecord(
      employeeName: employeeName!,
      startTime: startTime!,
      endTime: endTime!,
      totalDuration: totalDuration,
      remark: remark,
      photoUrl: photoFile?.path, // 本地图片路径
    );

    widget.onSave(newRecord);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('添加调休记录')),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 选择员工
                Text('选择员工'),
                DropdownButton<String>(
                  value: employeeName,
                  hint: Text('请选择员工'),
                  isExpanded: true,
                  items: employeeList.map((String name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      employeeName = newValue;
                    });
                  },
                ),
                SizedBox(height: 16),

                Text(
                    '开始时间: ${startTime != null ? formatDateTime(startTime!) : "未选择"}'),
                ElevatedButton(
                    onPressed: _pickStartTime, child: Text('选择开始时间')),
                SizedBox(height: 16),

                Text(
                    '结束时间: ${endTime != null ? formatDateTime(endTime!) : "未选择"}'),
                ElevatedButton(onPressed: _pickEndTime, child: Text('选择结束时间')),
                SizedBox(height: 16),

                // 手动输入总时长
                TextField(
                  controller: totalDurationController,
                  decoration: InputDecoration(
                    labelText: '总时长 (格式: 小时:分钟)',
                    hintText: '例如: 2:30',
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
