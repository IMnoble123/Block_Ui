import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:net_carbons/data/checkout/create_order_payload/address.dart';
import 'package:net_carbons/data/checkout/create_order_payload/create_order_payload.dart';
import 'package:net_carbons/data/checkout/create_order_payload/product.dart';
import 'package:net_carbons/data/checkout/create_session_request_payload/create_session_request_payload.dart';
import 'package:net_carbons/data/checkout/create_session_request_payload/item.dart';
import 'package:net_carbons/data/checkout/create_session_request_payload/price_data.dart';
import 'package:net_carbons/data/checkout/create_session_request_payload/product_data.dart';
import 'package:net_carbons/data/checkout/repository.dart';
import 'package:net_carbons/data/core/general/failiure.dart';
import 'package:net_carbons/domain/cart/models/cart_modal.dart';
import 'package:net_carbons/domain/cart/models/coupon_modal.dart';
import 'package:net_carbons/domain/user_profile/modal/profile_modal.dart';
import 'package:net_carbons/presentation/checkout/bloc/checkout_bloc.dart';
import 'package:net_carbons/presentation/checkout/stripe_web/web_view.dart';

import '../../../app/dependency.dart';
import '../../../data/checkout/create_order_response/create_order_response.dart';
import '../../../data/checkout/create_session_request_payload/discount.dart';
import '../../../data/checkout/create_session_request_payload/recurring.dart';
import '../checkout_views/payment_page_view.dart';

final checkoutRepo = getIt<CheckoutRepository>();

class CheckoutHelper {
  static Future<dartz.Either<dynamic, Response>> createSession(
      List<Item> items,
      BillingAddressModal billingAddressModal,
      CouponStateModal? couponResponseModal,
      PaymentMode paymentMode,
      String email) async {
    var payload = CreateSessionRequestPayload(
        items: items,
        email: email,
        paymentMode: paymentMode.name,
        discounts: couponResponseModal != null
            ? [
                Discount(
                    coupon: paymentMode == PaymentMode.subscription
                        ? couponResponseModal.stripeSubscriptionId
                        : couponResponseModal.stripePaymentId)
              ]
            : []);
    try {
      print("=======================");

      log(jsonEncode(payload));

      print("=======================");
      final response = await Dio().post(
          "https://netcarbons.rayabharitechnologies.com/api/checkout_sessions",
          data: payload.toJson());
      if (response.statusCode == 200) {
        return dartz.Right(response);
      } else {
        return dartz.Left(ClientFailure(message: "Error in creating session"));
      }
    } on DioError catch (e) {
      //FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      return dartz.Left(e);
    }
  }

  static List<Item> createItems(CartModal cartModal, PaymentMode paymentMode) {
    List<Item> items = [];
    cartModal.products.forEach((key, product) {
      double price;
      String currency;

      if (product.priceLocal != null) {
        price = product.priceLocal!.price;
        currency = product.priceLocal!.currency;
      } else {
        price = product.priceInUsd.price;
        currency = product.priceInUsd.currency;
      }
      final item = Item(
          priceData: PriceData(
              currency: currency,
              productData: ProductData(
                  name: product.productModal.name,
                  images: product.productModal.image),
              unitAmountDecimal: paymentMode == PaymentMode.payment
                  ? "${(price * 100).toInt()}"
                  : "${(price * 100) ~/ 12}",
              recurring: paymentMode == PaymentMode.subscription
                  ? Recurring(interval: "month")
                  : null),
          quantity: product.quantity);
      items.add(item);
    });
    return items;
  }

  static Future<dartz.Either<Failure, CreateOrderResponse>>
      createOrderAndRouteToTanksPageOnSuccessPayment(
          CheckoutState checkoutState,
          BillingAddressModal billingAddressModal,
          PaymentResult paymentResult,
          PaymentMode paymentMode) async {
    return await checkoutRepo.createOrder(createCreateOrderRequest(
        checkoutType: checkoutState.checkoutType,
        cartModal: CartModal(
            cartQuantity: checkoutState.cartQuantity,
            cartTotal: checkoutState.cartTotal,
            products: checkoutState.products,
            discount: checkoutState.discount,
            subTotal: checkoutState.subTotal,
            orderTotal: checkoutState.orderTotal),
        billingAddressModal: billingAddressModal,

        ///TODO Coupom
        couponCode: checkoutState.couponStateModal?.name ?? '',
        mode: paymentMode.name,
        sessionId: paymentResult.sessionId));
  }

  static CreateOrderPayload createCreateOrderRequest(
      {required CartModal cartModal,
      required BillingAddressModal billingAddressModal,
      required String couponCode,
      required String mode,
      required String sessionId,
      required CheckoutType checkoutType}) {
    List<CreateOrderRequestProduct> products = [];

    cartModal.products.forEach((key, product) {
      products.add(CreateOrderRequestProduct(
          product: product.id,
          price: product.price,
          quantity: product.quantity));
    });

    String currency;
    String currencySymbol;

    if (cartModal.products.entries.first.value.priceLocal != null) {
      currency = cartModal.products.entries.first.value.priceLocal!.currency;
      currencySymbol =
          cartModal.products.entries.first.value.priceLocal!.currencySymbol;
    } else {
      currency = cartModal.products.entries.first.value.priceInUsd.currency;
      currencySymbol =
          cartModal.products.entries.first.value.priceInUsd.currencySymbol;
    }

    CreateOrderRequestAddress address = CreateOrderRequestAddress(
        firstName: billingAddressModal.firstName,
        lastName: billingAddressModal.lastName,
        contactNo: billingAddressModal.contactNo,
        addressLine1: billingAddressModal.addressLine1,
        addressLine2: billingAddressModal.addressLine2,
        city: billingAddressModal.city,
        state: billingAddressModal.state,
        country: billingAddressModal.country,
        pincode: billingAddressModal.pincode,
        stateCode: billingAddressModal.stateCode,
        countryCode: billingAddressModal.countryCode);

    return CreateOrderPayload(
        products: products,
        currency: currency,
        currencySymbol: currencySymbol,
        address: address,
        paymentStatus: "success",
        paymentMethod: "STRIPE",
        couponCode: couponCode,
        type: checkoutType.name,
        paymentMode: mode,
        customer: billingAddressModal.customerProfile,
        orderTotal: cartModal.orderTotal,
        sessionId: sessionId,
        origin: 'mobile',
        total: cartModal.orderTotal);
  }
}
