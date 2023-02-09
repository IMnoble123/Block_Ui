import 'package:json_annotation/json_annotation.dart';
import 'package:net_carbons/data/user_profile/order_fetch_response/payment_log_response/payment_log_response.dart';
import 'package:net_carbons/data/user_profile/response/profile_response.dart';

import 'certificate.dart';
import 'customer.dart';
import 'invoice.dart';
import 'product.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  @JsonKey(name: '_id')
  String? id;
  String? orderNumber;
  List<OrderProductElement>? products;
  Customer? customer;
  double? orderTotal;
  double? calculatedCouponDiscount;
  double? subTotal;
  BillingAddressResponse? billingAddress;
  double? carbonOffsetEarned;
  String? paymentMode;
  String? paymentMethod;
  List<PaymentLogResponse>? paymentLogs;
  String? paymentStatus;
  int? subscriptionCancelledAt;
  int? isSubscriptionCycleCompleted;
  List<Certificate>? certificates;
  int? status;
  double? emailSentStatus;
  @JsonKey(name: 'currency')
  String? currency;
  @JsonKey(name: 'currencySymbol')
  String? currencySymbol;
  double? metricsCalculatedStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: '__v')
  int? v;
  Invoice? invoice;
  String? couponCode;

  Order(
      {this.id,
      this.couponCode,
      this.orderNumber,
      this.products,
      this.customer,
      this.orderTotal,
      this.calculatedCouponDiscount,
      this.subTotal,
      this.billingAddress,
      this.carbonOffsetEarned,
      this.paymentMode,
      this.paymentMethod,
      this.paymentLogs,
      this.paymentStatus,
      this.subscriptionCancelledAt,
      this.certificates,
      this.status,
      this.emailSentStatus,
      this.metricsCalculatedStatus,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.invoice,
      this.currencySymbol,
      this.currency,
      this.isSubscriptionCycleCompleted});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
