

class RecordModel {
  int id;
  double time;
  int userId;
  int imageId;
  String startTime;
  String endTime;

  RecordModel({
    this.id = 0,
    this.time = 0,
    this.userId = 0,
    this.imageId = 0,
    this.startTime = '',
    this.endTime = '',

  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'] ?? 0,
      time: json['time'] ?? 0,
      userId: json['userId'] ?? 0,
      imageId: json['imageId'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'userId': userId,
      'imageId': imageId,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  Map<String, dynamic> getAddJson() {
    return {
      'time': time,
      'userId': userId,
      'imageId': imageId,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

}