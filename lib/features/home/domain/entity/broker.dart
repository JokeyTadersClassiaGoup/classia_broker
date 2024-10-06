import '../../../../core/common/entity/ltp.dart';

class Broker {
  final String jockeyUid;
  final String jockeyName;
  final int lotValue;
  final List<Ltp> lots;
  final DateTime dateTime;
  // final double growth;
  final String at;
  // final double predictionValue;
  // final double successRation;

  Broker({
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
}
