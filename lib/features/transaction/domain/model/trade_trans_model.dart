import '../entity/trade_trans.dart';

class TradeTransModel extends TradeTrans {
  TradeTransModel(
      {required super.uid,
      required super.tradeId,
      required super.brokerUid,
      required super.brokerName,
      required super.dateTime,
      required super.amount,
      required super.quantity,
      required super.transType,
      required super.lotValue,
      required super.status,
      required super.validity});

  TradeTransModel copyWith({
    String? uid,
    String? tradeId,
    String? brokerUid,
    String? brokerName,
    DateTime? dateTime,
    int? amount,
    int? quantity,
    String? transType,
    double? lotValue,
    String? status,
    String? validity,
  }) {
    return TradeTransModel(
      uid: uid ?? this.uid,
      tradeId: tradeId ?? this.tradeId,
      brokerUid: brokerUid ?? this.brokerUid,
      brokerName: brokerName ?? this.brokerName,
      dateTime: dateTime ?? this.dateTime,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      transType: transType ?? this.transType,
      lotValue: lotValue ?? this.lotValue,
      status: status ?? this.status,
      validity: validity ?? this.validity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'tradeId': tradeId,
      'brokerUid': brokerUid,
      'brokerName': brokerName,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'amount': amount,
      'quantity': quantity,
      'transType': transType,
      'lotValue': lotValue,
      'status': status,
      'validity': validity,
    };
  }

  factory TradeTransModel.fromMap(Map<String, dynamic> map) {
    return TradeTransModel(
      uid: map['uid'] as String,
      tradeId: map['tradeId'] as String,
      brokerUid: map['brokerUid'] as String,
      brokerName: map['brokerName'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      amount: map['amount'] as int,
      quantity: map['quantity'] as int,
      transType: map['transType'] as String,
      lotValue: map['lotValue'] as double,
      status: map['status'] as String,
      validity: map['validity'] as String,
    );
  }
}
