import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:statistics_app/model/image_model.dart';
import 'package:statistics_app/pages/time_off_record.dart';
import 'dart:io'; // 导入 File
import 'package:intl/intl.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';

import '../model/show_record_model.dart';
import '../utils/db/image_manager.dart'; // 导入 intl 来格式化时间


class TimeOffDetailPage extends StatefulWidget {
  final ShowRecordModel record;
  const TimeOffDetailPage({super.key, required this.record});

  @override
  State<TimeOffDetailPage> createState() => _TimeOffDetailPageState();
}

class _TimeOffDetailPageState extends State<TimeOffDetailPage> {


  late ShowRecordModel record;
  Uint8List? _imageBytes;


  @override
  void initState() {
    record = widget.record;
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    ImageModel? image = await ImageManager.getImageById(record.recordModel.imageId);
    if (image != null) {
      setState(() {
        _imageBytes = image.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('调休记录详情'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${record.recordModel.time.toStringAsFixed(1)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)).center(),
            Text('员工名称: ${record.userModel.name}', style: TextStyle(fontSize: 18)),
            Text('开始时间: ${record.recordModel.startTime}', style: TextStyle(fontSize: 18)),
            Text('结束时间: ${record.recordModel.endTime}', style: TextStyle(fontSize: 18)),
            // Text('时长: ${record.totalDuration.inHours} 小时', style: TextStyle(fontSize: 18)),
            Text('备注: ${record.recordModel.remarks}', style: TextStyle(fontSize: 18)),
            if (_imageBytes != null) ...[
              SizedBox(height: 20),
              Image.memory(
                _imageBytes!, // 使用 Image.memory 显示二进制数据
                width: MediaQuery.of(context).size.width,
                height: 300,
              ),
            ]
          ],
        ),
      ),
    );
  }
}





