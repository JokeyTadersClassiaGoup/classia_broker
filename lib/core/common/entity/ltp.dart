class Ltp {
  final String instrumentKey;
  final dynamic lastPrice;
  final String instrumentName;
  final String segment;
  final String tradingSymbol;

  Ltp({
    required this.instrumentKey,
    required this.lastPrice,
    required this.instrumentName,
    required this.segment,
    required this.tradingSymbol,
  });

  factory Ltp.fromMap(Map<String, dynamic> map) {
    return Ltp(
      instrumentKey: map['instrumentKey'],
      lastPrice: map['lastPrice'],
      instrumentName: map['instrumentName'],
      segment: map['segment'],
      tradingSymbol: map['tradingSymbol'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'instrumentKey': instrumentKey,
      'lastPrice': lastPrice,
      'instrumentName': instrumentName,
      'segment': segment,
      'tradingSymbol': tradingSymbol,
    };
  }
}
