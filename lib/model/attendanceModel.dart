class AttendanceModel {
  final String inDateTime;
  final String outDateTime;
  final String inOutStatus;

  AttendanceModel({
    this.inDateTime,
    this.outDateTime,
    this.inOutStatus,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> parsedJson) {
    return AttendanceModel(
      inDateTime: parsedJson['InDateTime'],
      outDateTime: parsedJson['OutDateTime'],
      inOutStatus: parsedJson['InOutStatus'],
    );
  }
}
