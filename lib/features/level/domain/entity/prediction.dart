class Prediction {
  // final int lotValue;
  final double predictionValue;
  final DateTime dateTime;
  final String predictionId;
  final String jokeyUid;
  final double achived;
  final String title;
  final String? note;

  // final LotId lotId;
  // final double performance;

  Prediction({
    // required this.lotValue,
    required this.predictionValue,
    required this.dateTime,
    required this.predictionId,
    required this.jokeyUid,
    required this.achived,
    required this.title,
    required this.note,
    // required this.lotId,
    // required this.performance,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'lotValue': lotValue,
      'predictionValue': predictionValue,
      'dateTime': dateTime.toIso8601String(),
      'predictionId': predictionId,
      'jokeyUid': jokeyUid,
      'achived': achived,
      'title': title,
      'note': note,
      // 'lotId': lotId.value,
      // 'performance': performance,
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
      // lotValue: map['lotValue'],
      predictionValue: map['predictionValue'],
      dateTime: DateTime.parse(map['dateTime']),
      predictionId: map['predictionId'],
      jokeyUid: map['jokeyUid'],
      achived: map['achived'],
      title: map['title'],
      note: map['note'],
      // lotId: map['lotId'],
      // performance: map['performance'],
    );
  }
}
