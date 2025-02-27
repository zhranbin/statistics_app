import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

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
      final body = await ImageManager.getImageBody(image.path);
      image.body = body;
      return image;
    }
    return null;
  }

  // 添加图片
  static Future<int> addImage(ImageModel image) async {
    if (image.body == null) return -1;
    final path = await saveImageToLocal(image.body!);
    image.path = path ?? '';
    // 插入数据库
    return await DBHelper.insert(imageTableName, image.getAddJson());
  }

  // 删除图片
  static Future<int> deleteImage(int id) async {
    List<Map<String, dynamic>> list = await DBHelper.query(
        imageTableName, where: 'id = $id');
    if (list.isNotEmpty) {
      final image = ImageModel.fromJson(list.first);
      await deleteImageFromLocal(image.path);
    }
    // 删除数据库
    return await DBHelper.delete(imageTableName, where: 'id = $id');
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