class MyClassModel {
  final String durationFrom;
  final String durationTo;
  final String className;
  final String classInfo;
  final String classTime;
  final String fees;
  final String trainerName;

  MyClassModel(
      {this.durationFrom,
      this.durationTo,
      this.className,
      this.classInfo,
      this.classTime,
      this.fees,
      this.trainerName});

  factory MyClassModel.fromJson(Map<String, dynamic> parsedJson) {
    return MyClassModel(
      durationFrom:parsedJson['DurationFrom'],
      durationTo:parsedJson['DurationTo'],
      className: parsedJson['ClassName'],
      classInfo: parsedJson['ClassInfo'],
      classTime: parsedJson['ClassTime'],
      fees: parsedJson['Fees'],
      trainerName: parsedJson['TrainerName'],
    );
  }
}
