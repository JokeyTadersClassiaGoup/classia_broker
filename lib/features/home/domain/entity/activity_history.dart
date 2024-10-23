import 'package:classia_broker/core/common/entity/ltp.dart';

class ActivityHistory {
  final List<Ltp> lots;
  final Activity activity;
  final int performance;
  ActivityHistory({
    required this.lots,
    required this.activity,
    required this.performance,
  });
}

class Activity {
  final DateTime dateTime;
  final int lotValue;

  Activity({required this.dateTime, required this.lotValue});
}
