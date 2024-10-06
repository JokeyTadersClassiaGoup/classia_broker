class Order {
  final int quantity;
  final String product;
  final String validity;
  final double price;
  final String tag;
  final String instrumentToken;
  final String orderType;
  final String transactionType;
  final int disclosedQuantity;
  final int triggerPrice;
  final bool isAmo;

  Order({
    required this.quantity,
    required this.product,
    required this.validity,
    required this.price,
    required this.tag,
    required this.instrumentToken,
    required this.orderType,
    required this.transactionType,
    required this.disclosedQuantity,
    required this.triggerPrice,
    required this.isAmo,
  });

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        quantity: json["quantity"],
        product: json["product"],
        validity: json["validity"],
        price: json["price"],
        tag: json["tag"],
        instrumentToken: json["instrument_token"],
        orderType: json["order_type"],
        transactionType: json["transaction_type"],
        disclosedQuantity: json["disclosed_quantity"],
        triggerPrice: json["trigger_price"],
        isAmo: json["is_amo"],
      );

  Map<String, dynamic> toMap() => {
        "quantity": quantity,
        "product": product,
        "validity": validity,
        "price": price,
        "tag": tag,
        "instrument_token": instrumentToken,
        "order_type": orderType,
        "transaction_type": transactionType,
        "disclosed_quantity": disclosedQuantity,
        "trigger_price": triggerPrice,
        "is_amo": isAmo,
      };
}
