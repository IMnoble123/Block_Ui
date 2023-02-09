import 'package:dartz/dartz.dart';
import 'package:net_carbons/data/checkout/create_order_payload/create_order_payload.dart';
import 'package:net_carbons/data/core/general/failiure.dart';

abstract class ICheckoutRepository<T> {
  Future<Either<Failure, T>> createOrder(CreateOrderPayload createOrderRequest);
  Future<Either<Failure, T>> getOnOrder(String orderId, String currency);
}
