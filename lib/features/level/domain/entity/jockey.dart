import '../../../../core/common/entity/ltp.dart';

class Jokey {
  final String jockeyUid;
  final String jockeyName;
  final int lotValue;
  final List<Ltp> lots;
  final DateTime dateTime;
  // final double growth;
  final String at;
  // final double predictionValue;
  // final double successRation;

  Jokey({
    required this.jockeyUid,
    required this.jockeyName,
    required this.lotValue,
    required this.lots,
    required this.dateTime,
    // required this.growth,
    required this.at,
    // required this.predictionValue,
    // required this.successRation,
  });

  factory Jokey.fromMap(Map<dynamic, dynamic> map) {
    return Jokey(
      jockeyUid: map['jockeyUid'],
      jockeyName: map['jockeyName'],
      lotValue: map['lotValue'],
      lots:
          (map['lots'] as List).map((element) => Ltp.fromMap(element)).toList(),
      dateTime: DateTime.parse(map['dateTime']),
      // growth: map['growth'],
      at: map['at'],
      // predictionValue: map['predictionValue'],
      // successRation: map['successRation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jockeyUid': jockeyUid,
      'jockeyName': jockeyName,
      'lotValue': lotValue,
      'lots': lots.map((lot) => lot.toMap()).toList(),
      'dateTime': dateTime.toIso8601String(),
      // 'growth': growth,
      'at': at,
      // 'predictionValue': predictionValue,
      // 'successRation': successRation,
    };
  }
}

// class LotLtp {
//   final String instrumentKey;
//   final int lastPrice;

//   LotLtp({required this.instrumentKey, required this.lastPrice});

//   factory LotLtp.fromMap(Map<String, dynamic> map) {
//     return LotLtp(
//         instrumentKey: map['instrumentKey'], lastPrice: map['last_price']);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'instrumentKey': instrumentKey,
//       'ltp': lastPrice,
//     };
//   }
// }
