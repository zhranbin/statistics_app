import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String dbName = 'ab_database.db';
const String accountDbTableName = 'account_table';

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
    String path = join(await getDatabasesPath(), dbName);
    // 打开数据库
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $accountDbTableName (
            `address` varchar(32) NULL ,
            `keystore` text NULL ,
            `name` varchar(255) NULL ,
            `privateKey` varchar(64) NULL ,
            `mnemonic` varchar(255) NULL ,
            `createdAt` varchar(255) NULL ,
            `isDefault` int NULL DEFAULT 0 ,
            `isEncryption` int NULL DEFAULT 0 ,
            `extension` longtext NULL ,
            CONSTRAINT `isDefault` CHECK (isDefault IN (0, 1)),
            CONSTRAINT `isEncryption` CHECK (isEncryption IN (0, 1))
          )
        ''');
        return ;

        // // 创建表的SQL语句
        // return db.execute('''
        //   CREATE TABLE $accountDbTableName (
        //     address TEXT,
        //     keystore TEXT,
        //     name TEXT,
        //     privateKey TEXT,
        //     mnemonic TEXT,
        //     extension TEXT,
        //     createdAt TEXT,
        //     isDefault INTEGER DEFAULT 0 CHECK (isDefault IN (0, 1)),
        //     isEncryption INTEGER DEFAULT 0 CHECK (isEncryption IN (0, 1))
        //   )
        // ''');
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
}
