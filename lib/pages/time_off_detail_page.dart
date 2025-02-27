import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:statistics_app/model/image_model.dart';
import 'package:statistics_app/pages/time_off_record.dart';
import 'dart:io'; // 导入 File
import 'package:intl/intl.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';

import '../model/show_record_model.dart';
import '../utils/db/image_manager.dart';
import '../utils/my_shared_preferences.dart'; // 导入 intl 来格式化时间

class TimeOffDetailPage extends StatefulWidget {
  final ShowRecordModel record;
  const TimeOffDetailPage({super.key, required this.record});

  @override
  State<TimeOffDetailPage> createState() => _TimeOffDetailPageState();
}

class _TimeOffDetailPageState extends State<TimeOffDetailPage> {
  late ShowRecordModel record;
  Uint8List? _imageBytes;
  String _imagePath = '';

  @override
  void initState() {
    record = widget.record;
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    ImageModel? image =
        await ImageManager.getImageById(record.recordModel.imageId);
    final host = await MySharedPreferences.getLocalServerIP() ?? "";
    if (image != null) {
      setState(() {
        _imagePath = '${host}/${image.path}';
      });
    }
  }

  // 进入全屏图片浏览器页面
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    // if (_imageBytes != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imageUrl: imageUrl,),
      ),
    );
    // }
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
            Text('${record.recordModel.time.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                .center(),
            Text('员工名称: ${record.userModel.name}',
                style: TextStyle(fontSize: 18)),
            Text('开始时间: ${record.recordModel.startTime}',
                style: TextStyle(fontSize: 18)),
            Text('结束时间: ${record.recordModel.endTime}',
                style: TextStyle(fontSize: 18)),
            Text('备注: ${record.recordModel.remarks}',
                style: TextStyle(fontSize: 18)),
            // if (_imageBytes != null) ...[
            SizedBox(height: 20),
            GestureDetector(
                onTap: () => _showFullScreenImage(context, _imagePath), // 点击图片查看大图

                child: Image.network(
                  _imagePath,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // 图片加载完成
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('加载图片失败'),
                    );
                  },
                )),
            // ]
          ],
        ),
      ),
    );
  }
}

// 全屏图片页面
class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  // const FullScreenImagePage({super.key, required this.imageBytes});
  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 背景颜色为黑色
      body: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true, // 支持平移
            boundaryMargin: EdgeInsets.all(80), // 边界允许区域
            minScale: 0.1, // 最小缩放比例
            maxScale: 4.0, // 最大缩放比例
            child: Center(
              // child: Image.memory(
              //   imageBytes,
              //   fit: BoxFit.contain, // 保持图片的宽高比
              // ),
              child: Image.network(
                imageUrl, // 替换为图片的 URL
                fit: BoxFit.contain, // 保持图片的宽高比
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                // Navigator.pop(context); // 关闭全屏
                Navigator.of(context).pop(); // 关闭全屏
              },
            ),
          ),
        ],
      ),
    );
  }
}
