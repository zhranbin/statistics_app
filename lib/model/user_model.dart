class UserModel {
  int id;
  String name;
  String positions;
  double time;

  UserModel({
    this.id = 0,
    this.name = '',
    this.positions = '',
    this.time = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      positions: json['positions'] ?? '',
      time: json['time'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'positions': positions,
      'time': time,
    };
  }

  Map<String, dynamic> getAddJson() {
    return {
      'name': name,
      'positions': positions,
      'time': time,
    };
  }
}