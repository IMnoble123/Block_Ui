// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequestProduct _$CreateOrderRequestProductFromJson(
        Map<String, dynamic> json) =>
    CreateOrderRequestProduct(
      product: json['product'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
    );

Map<String, dynamic> _$CreateOrderRequestProductToJson(
        CreateOrderRequestProduct instance) =>
    <String, dynamic>{
      'product': instance.product,
      'price': instance.price,
      'quantity': instance.quantity,
    };
