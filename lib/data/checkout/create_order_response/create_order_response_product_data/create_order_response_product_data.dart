import 'package:json_annotation/json_annotation.dart';

part 'create_order_response_product_data.g.dart';

@JsonSerializable()
class CreateOrderResponseProductData {
  @JsonKey(name: '_id')
  String? id;
  String? name;

  CreateOrderResponseProductData({this.id, this.name});

  factory CreateOrderResponseProductData.fromJson(Map<String, dynamic> json) {
    return _$CreateOrderResponseProductDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CreateOrderResponseProductDataToJson(this);
  }
}
