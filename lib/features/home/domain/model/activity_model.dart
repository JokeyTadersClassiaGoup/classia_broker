import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/common/entity/ltp.dart';
import '../entity/activity.dart';

class ActivityModel extends Activity {
  ActivityModel({
    required super.brokerUid,
    required super.brokerName,
    required super.lotValue,
    required super.lots,
    required super.dateTime,
    required super.at,
    required super.activityId,
    required super.profit,
    required super.activeTime,
    required super.closeTime,
    required super.openingBalance,
    required super.closingBalance,
    required super.activityStatus,
    required super.totalInvest,
    required super.totalWithdraw,
  });

  ActivityModel copyWith({
    String? activityId,
    String? brokerUid,
    String? brokerName,
    int? lotValue,
    List<Ltp>? lots,
    Timestamp? dateTime,
    String? at,
    double? profit,
    Timestamp? activeTime,
    Timestamp? closeTime,
    double? openingBalance,
    double? closingBalance,
    String? activityStatus,
    double? totalInvest,
    double? totalWithdraw,
  }) {
    return ActivityModel(
      activityId: activityId ?? this.activityId,
      brokerUid: brokerUid ?? this.brokerUid,
      brokerName: brokerName ?? this.brokerName,
      lotValue: lotValue ?? this.lotValue,
      lots: lots ?? this.lots,
      dateTime: dateTime ?? this.dateTime,
      at: at ?? this.at,
      profit: profit ?? this.profit,
      activeTime: activeTime ?? this.activeTime,
      closeTime: closeTime ?? this.closeTime,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      activityStatus: activityStatus ?? this.activityStatus,
      totalInvest: totalInvest ?? this.totalInvest,
      totalWithdraw: totalWithdraw ?? this.totalWithdraw,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activityId': activityId,
      'brokerUid': brokerUid,
      'brokerName': brokerName,
      'lotValue': lotValue,
      'lots': lots.map((x) => x.toMap()).toList(),
      'dateTime': dateTime,
      'at': at,
      'profit': profit,
      'activeTime': activeTime,
      'closeTime': closeTime,
      'openingBalance': openingBalance,
      'closingBalance': closingBalance,
      'activityStatus': activityStatus,
      'totalInvest': totalInvest,
      'totalWithdraw': totalWithdraw,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      activityId: map['activityId'] as String,
      brokerUid: map['brokerUid'] as String,
      brokerName: map['brokerName'] as String,
      lotValue: map['lotValue'] as int,
      lots: List<Ltp>.from(
        (map['lots'] as List<dynamic>).map<Ltp>(
          (x) => Ltp.fromMap(x as Map<String, dynamic>),
        ),
      ),
      dateTime: map['dateTime'],
      at: map['at'] as String,
      profit: map['profit'] as double,
      activeTime: (map['activeTime'] as Timestamp),
      closeTime: (map['closeTime'] as Timestamp),
      openingBalance: map['openingBalance'] as double,
      closingBalance: map['closingBalance'] as double,
      activityStatus: map['activityStatus'] as String,
      totalInvest: map['totalInvest'],
      totalWithdraw: map['totalWithdraw'],
    );
  }
}
