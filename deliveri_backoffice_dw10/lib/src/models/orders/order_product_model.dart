import 'dart:convert';

class OrderProductModel {
  final int productIid;
  final int amount;
  final double totalPrice;

  OrderProductModel({
    required this.productIid,
    required this.amount,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': productIid,
      'amount': amount,
      'total_price': totalPrice,
    };
  }

  factory OrderProductModel.fromMap(Map<String, dynamic> map) {
    return OrderProductModel(
      productIid: map['id']?.toInt() ?? 0,
      amount: map['amount']?.toInt() ?? 0,
      totalPrice: map['total_price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderProductModel.fromJson(String source) =>
      OrderProductModel.fromMap(json.decode(source));
}
