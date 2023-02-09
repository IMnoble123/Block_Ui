import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: '_id')
  String? id;
  String? product;
  ReviewCustomerResponse? customer;
  String? order;
  double? approvedRating;
  String? approvedComment;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: '__v')
  int? v;

  Datum({
    this.id,
    this.product,
    this.customer,
    this.order,
    this.approvedRating,
    this.approvedComment,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
