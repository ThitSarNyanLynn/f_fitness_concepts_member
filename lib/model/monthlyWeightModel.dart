class MonthlyWeightModel {
  final int measureYear;
  final int measureMonth;
  final double averageWeight;

  MonthlyWeightModel({
    this.measureYear,
    this.measureMonth,
    this.averageWeight,
  });

  Map<String, dynamic> toMap() {
    return {
      'MeasureYear':measureYear,
      'MeasureMonth':measureMonth,
      'AverageWeight':averageWeight,
    };
  }

  // Implement toString to make it easier to see information about each MonthlyWeightModel when
  // using the print statement.
  @override
  String toString() {
    return '''MonthlyWeightModel:{$measureYear,$measureMonth, $averageWeight}''';
  }
}
