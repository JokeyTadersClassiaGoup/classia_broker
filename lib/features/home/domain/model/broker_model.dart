import '../../../../core/common/entity/ltp.dart';
import '../entity/broker.dart';

class BrokerModel extends Broker {
  BrokerModel({
    required super.jockeyUid,
    required super.jockeyName,
    required super.lotValue,
    required super.lots,
    required super.dateTime,
    required super.at,
  });

  factory BrokerModel.fromMap(Map<dynamic, dynamic> map) {
    return BrokerModel(
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
