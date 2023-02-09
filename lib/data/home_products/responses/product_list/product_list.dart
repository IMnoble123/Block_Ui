import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'product_list.g.dart';

@JsonSerializable()
class ProductList {
  @JsonKey(name: 'data')
  List<Product>? products;

  ProductList({this.products});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    final res = _$ProductListFromJson(json);

    return res;
  }

  Map<String, dynamic> toJson() => _$ProductListToJson(this);
}
