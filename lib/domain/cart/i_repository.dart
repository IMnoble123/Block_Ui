import 'package:dartz/dartz.dart';
import 'package:net_carbons/data/core/general/failiure.dart';
import 'package:net_carbons/domain/cart/models/cart_modal.dart';
import 'package:net_carbons/domain/cart/models/coupon_modal.dart';

import '../../data/cart/hiveModal/cart_hive_modal.dart';

abstract class ICartRepository<T> {
  Future<Either<Failure, T>> getCart();
  Future<void> saveCartToLocal(Map<String, ProductCartModal> products);
  Future<void> clearLocalCart();

  Future<Either<Failure, T>> getCartFromServer(String currency,
      {required bool getStripeCoupon});
  Future<Either<Failure, T>> saveCartToServer(
      Map<String, ProductCartModal> products,
      String currency,
      bool itemsPreLogin,
      {required bool getStripeCoupon});
  Future<Either<Failure, T>> applyCoupon(
      {required String type,
      required String code,
      required bool getStripeCoupon,
      String? productId,
      int? quantity});

  Future<Either<Failure, T>> calculateExpressCheckout(
      {required bool getStripeCoupon,
      required String productId,
      required int quantity,
      CouponStateModal? couponStateModal});

  Future<Either<Failure, T>> couponUnApply(String currency);
  Future<Either<Failure, T>> removeItem(
      String itemId, String currency, bool getStripeCoupon);

  //Future<Either<Failure, dynamic>> getCouponFromLocal();
  Future<void> clearCouponFromLocal();
}
