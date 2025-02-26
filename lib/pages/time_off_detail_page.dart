import 'package:flutter/material.dart';
import 'package:statistics_app/pages/time_off_record.dart';

class TimeOffDetailPage extends StatelessWidget {
  final TimeOffRecord record;

  TimeOffDetailPage({required this.record});

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
            Text('开始时间: ${record.startTime}', style: TextStyle(fontSize: 18)),
            Text('结束时间: ${record.endTime}', style: TextStyle(fontSize: 18)),
            Text('时长: ${record.totalDuration.inHours} 小时', style: TextStyle(fontSize: 18)),
            Text('备注: ${record.remark}', style: TextStyle(fontSize: 18)),
            if (record.photoUrl != null) ...[
              SizedBox(height: 20),
              Text('照片:'),
              Image.network(record.photoUrl!),
            ]
          ],
        ),
      ),
    );
  }
}
