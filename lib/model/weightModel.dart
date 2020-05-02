class WeightModel {
  final String measureDateTime;
  final int weight;
  final int measureMonth;
  final int measureYear;

  WeightModel({
    this.measureDateTime,
    this.weight,
    this.measureMonth,
    this.measureYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'MeasureDateTime': measureDateTime,
      'Weight': weight,
      'MeasureMonth':measureMonth,
      'MeasureYear':measureYear,
    };
  }

  // Implement toString to make it easier to see information about each WeightModel when
  // using the print statement.
  @override
  String toString() {
    return '''BodyWeight{: $measureDateTime, $weight, $measureMonth, $measureYear}''';
  }
}
