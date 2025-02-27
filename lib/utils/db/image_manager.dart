import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:statistics_app/main.dart';

import '../../model/image_model.dart';
import 'db_helper.dart';

class ImageManager {

  // 通过id获取图片
  static Future<ImageModel?> getImageById(int id) async {
    // 查询数据库
    List<Map<String, dynamic>> list = await DBHelper.query(
        imageTableName, where: 'id = $id');
    if (list.isNotEmpty) {
      final image = ImageModel.fromJson(list.first);
      return image;
    }
    return null;
  }

  // 添加图片
  static Future<int> addImage(ImageModel image) async {
    // 插入数据库
    return await DBHelper.insert(imageTableName, image.getAddJson());
  }

  // 删除图片
  static Future<int> deleteImage(int id) async {
    List<Map<String, dynamic>> list = await DBHelper.query(
        imageTableName, where: 'id = $id');
    if (list.isNotEmpty) {
      final image = ImageModel.fromJson(list.first);
      await deleteNetImage(image.path);
    }
    // 删除数据库
    return await DBHelper.delete(imageTableName, where: 'id = $id');
  }


  // 上传文件
  static Future<String?> uploadImage(File file) async {
    try {
      final uri = Uri.parse("http://10.0.0.169:9999/upload");  // 替换为你的上传 URL
      final name = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
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

  // 删除图片
  static Future<void> deleteNetImage(String name) async {
    // 10.0.0.169:9999/delete?name=<file_name>
    try {
      final uri = Uri.parse("http://10.0.0.169:9999/delete?name=$name");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(MyApp.context).showSnackBar(SnackBar(content: Text("删除成功")));
      } else {
        ScaffoldMessenger.of(MyApp.context).showSnackBar(SnackBar(content: Text("删除失败")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(MyApp.context).showSnackBar(SnackBar(content: Text("删除错误")));
    }
  }




  // 保存图片到本地
  static Future<String?> saveImageToLocal(Uint8List imageBytes, {String? fileExtension = 'jpg'}) async {
    try {
      // 获取应用的文档目录
      final directory = await getApplicationDocumentsDirectory();
      // 设置保存的文件路径（以时间戳为文件名避免重复）
      final String fileName = 'image_${DateTime
          .now()
          .millisecondsSinceEpoch}.$fileExtension';
      final String filePath = '${directory.path}/$fileName';

      // 创建文件实例
      final file = File(filePath);

      // 将二进制数据写入文件
      await file.writeAsBytes(imageBytes as List<int>);

      // 返回文件的路径
      return filePath;
    } catch (e) {
      // 错误处理
      print("保存图片时出错: $e");
      return null; // 如果发生错误，返回 null
    }
  }

  // 从本地路径删除图片
  static Future<void> deleteImageFromLocal(String filePath) async {
    try {
      // 创建文件实例
      final file = File(filePath);
      // 删除文件
      await file.delete();
    } catch (e) {
      // 错误处理
      print("删除图片时出错: $e");
    }
  }

  // 通过图片本地路径获取二进制数据
  static Future<Uint8List?> getImageBody(String path) async {
    try {
      // 创建文件实例
      final file = File(path);
      // 读取文件内容
      final bytes = await file.readAsBytes();
      // 返回二进制数据
      return bytes;
    } catch (e) {
      // 错误处理
      print("读取图片时出错: $e");
      return null; // 如果发生错误，返回 null
    }
  }
}