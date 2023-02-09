import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class CreateOrderRequestProduct {
  String? product;
  double? price;
  int? quantity;

  CreateOrderRequestProduct({this.product, this.price, this.quantity});

  factory CreateOrderRequestProduct.fromJson(Map<String, dynamic> json) {
    return _$CreateOrderRequestProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CreateOrderRequestProductToJson(this);
}
