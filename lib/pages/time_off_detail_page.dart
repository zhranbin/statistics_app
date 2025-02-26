import 'package:flutter/material.dart';
import 'package:statistics_app/pages/time_off_record.dart';
import 'dart:io'; // 导入 File
import 'package:intl/intl.dart'; // 导入 intl 来格式化时间

class TimeOffDetailPage extends StatelessWidget {
  final TimeOffRecord record;

  TimeOffDetailPage({required this.record});

  // 格式化时间，去掉毫秒
  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
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
            Text('员工名称: ${record.employeeName}', style: TextStyle(fontSize: 18)),
            Text('开始时间: ${formatDateTime(record.startTime)}', style: TextStyle(fontSize: 18)),
            Text('结束时间: ${formatDateTime(record.endTime)}', style: TextStyle(fontSize: 18)),
            Text('时长: ${record.totalDuration.inHours} 小时', style: TextStyle(fontSize: 18)),
            Text('备注: ${record.remark}', style: TextStyle(fontSize: 18)),
            if (record.photoUrl != null) ...[
              SizedBox(height: 20),
              Text('照片:'),
              record.photoUrl!.startsWith('http') // 如果是 URL
                  ? Image.network(record.photoUrl!) // 网络图片
                  : Image.file(File(record.photoUrl!)), // 本地图片
            ]
          ],
        ),
      ),
    );
  }
}
