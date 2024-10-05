class OrderPageArgs {
  final bool orderType;
  final double lastTradedPrice;
  final String title;
  final double availableBalance;
  final String accessToken;
  final String instrumentKey;

  OrderPageArgs({
    required this.orderType,
    required this.lastTradedPrice,
    required this.title,
    required this.availableBalance,
    required this.accessToken,
    required this.instrumentKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderType': orderType,
      'lastTradedPrice': lastTradedPrice,
      'title': title,
      'availableBalance': availableBalance,
      'accessToken': accessToken,
      'instrumentKey': instrumentKey,
    };
  }

  factory OrderPageArgs.fromMap(Map<String, dynamic> map) {
    return OrderPageArgs(
      orderType: map['orderType'],
      lastTradedPrice: map['lastTradedPrice'],
      title: map['title'],
      availableBalance: map['availableBalance'],
      accessToken: map['accessToken'],
      instrumentKey: map['instrumentKey'],
    );
  }
}
