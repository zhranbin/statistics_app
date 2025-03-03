import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import '../my_shared_preferences.dart';
import 'db_helper.dart';

class BackupManager {


  static backupUsers() async {
    List<Map<String, dynamic>> result = await DBHelper.query(userTableName);
    print("备份用户");
    await uploadData(result, prefix: 'user');
  }

  static backupImages() async {
    List<Map<String, dynamic>> result = await DBHelper.query(imageTableName);
    await uploadData(result, prefix: 'image');
  }

  static backupRecords() async {
    List<Map<String, dynamic>> result = await DBHelper.query(recordTableName);
    await uploadData(result, prefix: 'record');
  }



  // 将数据写入文件并上传
  static Future<void> uploadData(List<Map<String, dynamic>> data, {String prefix = 'file'}) async {
    try {
      // 将数据转换为 JSON 字符串
      String jsonData = jsonEncode(data);
      // 获取应用的文档目录
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/data_${DateTime.now().millisecondsSinceEpoch}.txt'; // 创建一个文件路径
      // 创建文件并写入数据
      final file = File(filePath);
      await file.writeAsString(jsonData);
      // 上传文件
      final uploadResult = await uploadFile(file, prefix: prefix, fileExtension: 'txt');
      if (uploadResult != null) {
        print("上传成功，文件名：$uploadResult");
        // 上传成功后删除本地文件
        await file.delete();
        print("本地文件已删除");
      } else {
        print("上传失败");
      }
    } catch (e) {
      print("发生错误: $e");
    }
  }



  // 上传文件
  static Future<String?> uploadFile(File file, {String prefix = 'file', String fileExtension = 'jpg'}) async {
    try {
      final host = await MySharedPreferences.getLocalServerIP() ?? "";
      final uri = Uri.parse("$host/upload");  // 替换为你的上传 URL
      final name = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      var request = http.MultipartRequest('POST', uri)
        ..fields['name'] = name  // 可选字段
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('application', 'octet-stream'),
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(MyApp.context).showSnackBar(SnackBar(content: Text("上传成功")));
        return name;
      } else {
        ScaffoldMessenger.of(MyApp.context).showSnackBar(SnackBar(content: Text("上传失败")));
        return null;
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(MyApp.context).showSnackBar(SnackBar(content: Text("上传错误")));
      return null;
    }
  }


}