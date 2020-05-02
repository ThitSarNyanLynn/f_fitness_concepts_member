class TrainerModel {
  final int trainerID;
  final String trainerPhoto;
  final String trainerName;

  TrainerModel({
    this.trainerID,
    this.trainerPhoto,
    this.trainerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'TrainerID': trainerID,
      'TrainerPhoto': trainerPhoto,
      'TrainerName': trainerName,
    };
  }

  // Implement toString to make it easier to see information about each TrainerModel when
  // using the print statement.
  @override
  String toString() {
    return '''TrainerModel:{$trainerID,$trainerPhoto,$trainerName,}''';
  }
}
