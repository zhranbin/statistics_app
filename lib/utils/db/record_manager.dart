import 'dart:typed_data';
import 'dart:ui';

import 'package:statistics_app/model/image_model.dart';
import 'package:statistics_app/utils/db/image_manager.dart';

import '../../model/record_model.dart';
import 'db_helper.dart';

class RecordManager {

  // 获取所有记录
  static Future<List<RecordModel>> getAllRecords({int? userId}) async {
    List<RecordModel> list = [];
    List<Map<String, dynamic>> result = await DBHelper.query(recordTableName, where: (userId != null ? 'userId = $userId' : null));
    for (var item in result) {
      list.add(RecordModel.fromJson(item));
    }
    await DBHelper.close();
    return list.reversed.toList();
  }

  // 添加记录
  static Future<int> addRecord({required int time, required int userId, required Uint8List imageBody, required String startTime, required String endTime}) async {
    ImageModel image = ImageModel(body: imageBody);
    final imageId = await ImageManager.addImage(image);
    RecordModel record = RecordModel(time: time, userId: userId, imageId: imageId, startTime: startTime, endTime: endTime);
    int id = await DBHelper.insert(recordTableName, record.getAddJson());
    await DBHelper.close();
    return id;
  }

  // 添加记录
  static Future<int> addNewRecord(RecordModel record) async {
    int id = await DBHelper.insert(recordTableName, record.getAddJson());
    await DBHelper.close();
    return id;
  }

  // 删除记录
  static Future<int> deleteRecord(int id) async {
    int result = await DBHelper.delete(recordTableName, where: 'id = $id');
    await DBHelper.close();
    return result;
  }
}