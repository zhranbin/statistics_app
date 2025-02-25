import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String chainDbName = 'chain_db_name.db';
// user表
const String userTableName = 'network_table_name';
// 记录表
const String recordTableName  = 'node_table_name';
// 图片表
const String imageTableName = 'token_table_name';

class DBHelper {
  static Database? _database; // 使用问号表示可能为null

  // 单例模式获取数据库实例
  static Future<Database> get database async {
    if (_database != null) return _database!; // 使用感叹号来解包
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化数据库
  static Future<Database> _initDatabase() async {
    // 获取数据库文件的路径
    String path = join(await getDatabasesPath(), chainDbName);
    // 打开数据库
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE "$userTableName" (
        "id" INTEGER NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT,
        "name" TEXT,
        "positions" TEXT,
        "time" INTEGER NOT NULL DEFAULT 0,
        )
        ''');

        await db.execute('''
        CREATE TABLE "$recordTableName" (
        "id" INTEGER NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT,
        "time" INTEGER NOT NULL DEFAULT 0,
        "userId" INTEGER NOT NULL,
        "imageId" INTEGER NOT NULL,
        "startTime" TEXT,
        "endTime" TEXT,
        )
        ''');

        await db.execute('''
        CREATE TABLE "$imageTableName" (
        "id" INTEGER NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT,
        "body" MEDIUMBLOB NOT NULL,
        "recordId" INTEGER NOT NULL,
        )
        ''');
        return ;
      },
    );
  }

  // 插入数据
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data);
  }

  // 查询数据
  static Future<List<Map<String, dynamic>>> query(String table,
      {String? where, String? orderBy}) async {
    final db = await database;
    return db.query(table, where: where, orderBy: orderBy);
  }

  // 更新数据
  static Future<int> update(String table, Map<String, dynamic> values,
      {String? where}) async {
    final db = await database;
    return db.update(table, values, where: where);
  }

  // 删除数据
  static Future<int> delete(String table, {String? where}) async {
    final db = await database;
    return db.delete(table, where: where);
  }

  // 关闭数据库
  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null; // 重置单例
    }
  }


  // 执行事务
  static Future<T> executeTransaction<T>(Future<T> Function(Transaction txn) action, {bool? exclusive}) async {
    final db = await database;
    return db.transaction(action, exclusive: exclusive);
  }

}
