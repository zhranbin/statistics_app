import 'package:statistics_app/model/record_model.dart';
import 'package:statistics_app/model/user_model.dart';

import 'image_model.dart';

class ShowRecordModel {
  RecordModel recordModel;
  // ImageModel? imageModel;
  UserModel userModel;

  ShowRecordModel({
    required this.recordModel,
    required this.userModel,
  });
}