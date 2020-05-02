class WeightYearModel {
  final int measureYear;

  WeightYearModel({
    this.measureYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'MeasureYear':measureYear,
    };
  }

  // Implement toString to make it easier to see information about each WeightYearModel when
  // using the print statement.
  @override
  String toString() {
    return '''WeightYearModel{: $measureYear}''';
  }
}
