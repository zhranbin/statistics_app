import 'dart:convert';


extension JsonString on String? {
  Map<String, dynamic>? get toJson {
    if (this == null) {
      return null;
    }
    try {
      return json.decode(this!);
    } catch (e) {
      return null;
    }
  }
}
