import 'dart:typed_data';

class ImageModel {
  int id;
  Uint8List? body;
  String path;

  ImageModel({
    this.id = 0,
    this.body,
    this.path = '',
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      body: json['body'],
      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'path': path,
    };
  }

  Map<String, dynamic> getAddJson() {
    return {
      'path': path,
    };
  }


}