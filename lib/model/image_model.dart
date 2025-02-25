import 'dart:typed_data';

class ImageModel {
  int id;
  Uint8List? body;
  int recordId;

  ImageModel({
    this.id = 0,
    this.body,
    this.recordId = 0,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      body: json['body'],
      recordId: json['recordId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'recordId': recordId,
    };
  }

  Map<String, dynamic> getAddJson() {
    return {
      'body': body,
      'recordId': recordId,
    };
  }


}