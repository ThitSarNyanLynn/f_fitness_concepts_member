class GymClassModel {
  final String className;
  final String classInfo;
  final String classTime;
  final String fees;
  final String trainerName;

  GymClassModel(
      {this.className,
      this.classInfo,
      this.classTime,
      this.fees,
      this.trainerName});

  factory GymClassModel.fromJson(Map<String, dynamic> parsedJson) {
    return GymClassModel(
      className: parsedJson['ClassName'],
      classInfo: parsedJson['ClassInfo'],
      classTime: parsedJson['ClassTime'],
      fees: parsedJson['Fees'],
      trainerName: parsedJson['TrainerName'],
    );
  }
}
