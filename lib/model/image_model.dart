import 'dart:typed_data';

class ImageModel {
  int id;
  String path;

  ImageModel({
    this.id = 0,
    this.path = '',
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
    };
  }

  Map<String, dynamic> getAddJson() {
    return {
      'path': path,
    };
  }


}