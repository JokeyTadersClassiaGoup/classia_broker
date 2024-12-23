// ignore_for_file: public_member_api_docs, sort_constructors_first

class TradeTrans {
  final String uid;
  final String tradeId;
  final String brokerUid;
  final String brokerName;
  final DateTime dateTime;
  final int amount;
  final int quantity;
  final String transType;
  final double lotValue;
  final String status;
  final String validity;

  TradeTrans({
    required this.uid,
    required this.tradeId,
    required this.brokerUid,
    required this.brokerName,
    required this.dateTime,
    required this.amount,
    required this.quantity,
    required this.transType,
    required this.lotValue,
    required this.status,
    required this.validity,
  });
}
