import '../../model/image_model.dart';
import 'db_helper.dart';

class ImageManager {

  // 通过id获取图片
  static Future<ImageModel?> getImageById(int id) async {
    // 查询数据库
    List<Map<String, dynamic>> list = await DBHelper.query(imageTableName, where: 'id = $id');
    if (list.isNotEmpty) {
      return ImageModel.fromJson(list.first);
    }
    return null;
  }

  // 添加图片
  static Future<int> addImage(ImageModel image) async {
    // 插入数据库
    return await DBHelper.insert(imageTableName, image.getAddJson());
  }
}