import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../model/user_model.dart';
import 'db_helper.dart';

class UserManager {

  // 获取用户列表
  static Future<List<UserModel>> getUserList() async {
    List<UserModel> users = [];
    List<Map<String, dynamic>> result = await DBHelper.query(userTableName);
    for (var item in result) {
      users.add(UserModel.fromJson(item));
    }
    await DBHelper.close();
    return users.reversed.toList();
  }

  // 获取用户（通过id）
  static Future<UserModel?> getUser(int id) async {
    List<Map<String, dynamic>> result = await DBHelper.query(userTableName, where: 'id = $id');
    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    await DBHelper.close();
    return null;
  }

  // 添加用户
  static Future<int> addUser(UserModel user) async {
    int id = await DBHelper.insert(userTableName, user.getAddJson());
    await DBHelper.close();
    return id;
  }

  // 更新用户
  static Future<int> updateUser(UserModel user) async {
    int id = await DBHelper.update(userTableName, user.getAddJson(), where: 'id = ${user.id}',);
    await DBHelper.close();
    return id;
  }

  // 删除用户
  static Future<int> deleteUser(int id) async {
    int count = await DBHelper.delete(userTableName, where: 'id = $id');
    await DBHelper.close();
    return count;
  }


}