
import 'dart:convert';

import '../../models/product_model.dart';

class OrderProductDto {
  final ProductModel product;
  final int amount;
  final double totalPrice;
  OrderProductDto({
    required this.product,
    required this.amount,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'amount': amount,
      'totalPrice': totalPrice,
    };
  }

  factory OrderProductDto.fromMap(Map<String, dynamic> map) {
    return OrderProductDto(
      product: ProductModel.fromMap(map['product']),
      amount: map['amount']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderProductDto.fromJson(String source) => OrderProductDto.fromMap(json.decode(source));
}
