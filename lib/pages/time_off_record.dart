class TimeOffRecord {
  String employeeName;
  DateTime startTime;
  DateTime endTime;
  Duration totalDuration;
  String remark;
  String? photoUrl;

  TimeOffRecord({
    required this.employeeName,
    required this.startTime,
    required this.endTime,
    required this.totalDuration,
    required this.remark,
    this.photoUrl,
  });
}