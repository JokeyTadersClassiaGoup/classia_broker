class Ohlc {
  final double open;
  final double high;
  final double low;
  final double close;

  Ohlc({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory Ohlc.fromMap(Map<String, dynamic> json) => Ohlc(
        open: json["open"]?.toDouble(),
        high: json["high"]?.toDouble(),
        low: json["low"]?.toDouble(),
        close: json["close"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "open": open,
        "high": high,
        "low": low,
        "close": close,
      };
}
