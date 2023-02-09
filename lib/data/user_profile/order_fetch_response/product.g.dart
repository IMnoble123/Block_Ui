// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProductElement _$OrderProductElementFromJson(Map<String, dynamic> json) =>
    OrderProductElement(
      product: json['product'] == null
          ? null
          : FetchOrderProductData.fromJson(
              json['product'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toDouble(),
      quantity: json['quantity'] as int?,
      certificateNumber: json['certificateNumber'] as String?,
      id: json['_id'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OrderProductElementToJson(
        OrderProductElement instance) =>
    <String, dynamic>{
      'product': instance.product,
      'price': instance.price,
      'quantity': instance.quantity,
      'certificateNumber': instance.certificateNumber,
      '_id': instance.id,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
