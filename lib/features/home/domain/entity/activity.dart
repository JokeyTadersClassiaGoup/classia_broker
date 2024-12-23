// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/common/entity/ltp.dart';

class Activity {
  final String activityId;
  final String brokerUid;
  final String brokerName;
  final int lotValue;
  final List<Ltp> lots;
  final Timestamp dateTime;
  final double totalInvest;
  final double totalWithdraw;
  final String at;
  final double profit;
  final Timestamp activeTime;
  final Timestamp closeTime;
  final double openingBalance;
  final double closingBalance;
  final String activityStatus;

  Activity({
    required this.activityId,
    required this.brokerUid,
    required this.brokerName,
    required this.lotValue,
    required this.lots,
    required this.dateTime,
    required this.at,
    required this.totalInvest,
    required this.totalWithdraw,
    required this.profit,
    required this.activeTime,
    required this.closeTime,
    required this.openingBalance,
    required this.closingBalance,
    required this.activityStatus,
  });
}
