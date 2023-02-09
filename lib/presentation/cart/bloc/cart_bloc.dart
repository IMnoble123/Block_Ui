import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:net_carbons/app/app_controller/app_controller_bloc.dart';
import 'package:net_carbons/app/app_controller/state_classes/settings.dart';
import 'package:net_carbons/app/auth/auth_bloc.dart';
import 'package:net_carbons/app/dependency.dart';
import 'package:net_carbons/data/core/general/failiure.dart';
import 'package:net_carbons/domain/cart/models/apply_coupon.dart';
import 'package:net_carbons/domain/cart/models/cart_modal.dart';
import 'package:net_carbons/domain/cart/models/coupon_modal.dart';
import 'package:net_carbons/domain/cart/models/server_resp_modals.dart';
import 'package:net_carbons/presentation/home-products/bloc/products_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/cart/repository/cart_repository.dart';
import '../../../data/product/repository/repository.dart';

part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  final AuthBloc authBloc;
  final ProductsBloc productsBloc;
  final productRepo = getIt<SingleProductRepository>();
  final AppControllerBloc appControllerBloc;
  AppControllerState appControllerState = AppControllerState.initial(
      isLoading: false,
      countries: [],
      currencyList: [],
      currency: 'USD',
      appCustomSettings: AppCustomSettings(notificationEnabled: false),
      buildApp: false,
      showSnackBar: false,
      appLevelSnackBar: AppLevelSnackBar.empty());
  String currency = 'USD';
  AuthState authState = const AuthState.unauthenticated();
  late StreamSubscription authSubs;

  CartBloc(
      {required this.appControllerBloc,
      required this.productsBloc,
      required this.authBloc,
      required this.cartRepository})
      : super(CartState.initial()) {
    authBloc.stream.listen((event) async {
      print("Cart_bloc 52 authBloc.stream.listen $event");
      authState = event;
      if (event is Authenticated) {
        event.map((value) => null, authenticated: (authenticated) async {
          if (authenticated.shouldSyncLocalCartToServer) {
            final localCart = await cartRepository.getCart();
            localCart.fold((l) {}, (r) async {
              cartRepository.saveCartToServer({
                for (var v in r)
                  v.id: ProductCartModal.empty()
                      .copyWith(id: v.id, quantity: v.quantity)
              }, currency, true, getStripeCoupon: false)
                  .then((value) {
                add(const CartEvent.cartStarted());
                add(const CartEvent.setCartSyncedToServer(
                    CartSyncedToServerOnAuth.syncing));
                value.fold((l) {
                  add(const CartEvent.setCartSyncedToServer(
                      CartSyncedToServerOnAuth.failed));
                }, (r) {
                  add(const CartEvent.setCartSyncedToServer(
                      CartSyncedToServerOnAuth.synced));
                });
              });
              cartRepository.clearLocalCart();
            });
          }
          add(const CartEvent.cartStarted());
        },
            unauthenticated: (unauthenticated) {},
            loading: (loading) {},
            unknown: (unknown) {});

        return;
      } else if (event is Unauthenticated) {
        add(const CartEvent.clear());
      }
    });

    appControllerState = appControllerBloc.state;
    currency = appControllerState.currency;
    appControllerBloc.stream.listen((event) {
      if (event.appControllerEventsType ==
          AppControllerEventsType.appControllerEventUpdateCurrency) {
        add(CartEvent.saveCart(
            products: state.products,
            currency: event.currency,
            itemsPreLogin: false,
            saveActionType: SaveActionType.save,
            productCartModal: ProductCartModal.empty()));
      }

      appControllerState = event;
      currency = event.currency;
    });
    /////
    on<CartsetCartSyncedToServer>((event, emit) => emit(
        state.copyWith(cartSyncedToServer: event.cartSyncedToServerOnAuth)));

//////////////////////////
    on<CartApplyCoupon>((event, emit) async {
      emit(state.copyWith(isCouponLoading: true, isTotalsLoading: true));

      if (authState is Authenticated) {
        final res = await cartRepository.applyCoupon(
          type: 'regular',
          code: event.code,
          getStripeCoupon: false,
        );
        return res.fold((l) {
          // if (l is AccountHold) {
          //   authBloc.add(AuthEvent.logoutRequested());
          //   appControllerBloc.add(AppControllerEvent.setAppSnackBar(
          //       AppLevelSnackBar(
          //           message: "Your account is on hold, Please reset your password by clicking forgot password",
          //           duration: Duration(days: 360),
          //           showSnack: true)));
          // }
          return emit(state.copyWith(
              isTotalsLoading: false,
              isCouponLoading: false,
              isLoading: false,
              couponHasError: true,
              couponMessage: l.message));
        }, (ApplyCouponResponseModal r) {
          add(const CartEvent.cartStarted());
          // return emit(state.copyWith(
          //     couponStateModal: r.toCouponStateModal(),
          //     isCouponLoading: false,
          //     isLoading: false,
          //     couponHasError: false,
          //     orderTotal: r.total,
          //     subTotal: r.subTotal,
          //     discount: r.discount,
          //     couponMessage: ''));
        });
      }
      add(const CartEvent.calculateTotal());
    });
//////////////////////////
//     on<CartUpdateCoupon>((event, emit) {
//       CouponStateModal? couponStateModal =
//           event.couponStateModal.name.isNotEmpty
//               ? event.couponStateModal
//               : null;
//       emit(state.copyWith(
//
//           couponStateModal: couponStateModal,
//           orderTotal: event.orderTotal,
//           discount: event.discount,
//           subTotal: event.subTotal));
//       add(const CartEvent.calculateTotal());
//     });
//////////////////////////
    on<CartRemoveCoupon>((event, emit) async {
      emit(state.copyWith(isCouponLoading: true));
      cartRepository.clearCouponFromLocal();
      final res = await cartRepository.couponUnApply(currency);
      res.fold((l) => print("ERR"), (r) => print("OK"));
      emit(
        state.copyWith(
          isCouponLoading: false,
          couponStateModal: null,
          orderTotal: state.cartTotal,
          subTotal: state.cartTotal,
          discount: 0,
        ),
      );
      add(const CartEvent.calculateTotal());
    });
//////////////////////////
    on<CartStarted>((event, emit) async {
      print("CartStarted");
      emit(state.copyWith(isLoading: true));
      authState = authBloc.state;

      if (authState is Unauthenticated) {
        ////
        Map<String, ProductCartModal> products = {};
        int quantity = 0;

        /////

        await cartRepository.getCart().then((res) => res.fold((l) {
              emit(state.copyWith(isLoading: false));
            }, (localCartData) async {
              localCartData.forEach((item) async {
                quantity = quantity + item.quantity;

                productRepo
                    .fetchProductData(item.id, currency)
                    .then((res) => res.fold((l) {}, (singleProductData) async {
                          products[singleProductData.id] = singleProductData
                              .toProductCartModalWithQuantity(item.quantity);
                        }));
              });
            }));
        emit(CartState(
            isTotalsLoading: false,
            couponStateModal: null,
            isLoading: false,
            isCouponLoading: false,
            couponHasError: false,
            cartQuantity: quantity,
            cartTotal: products.entries.fold(
                0,
                (previousValue, element) =>
                    previousValue +
                    element.value.price * element.value.quantity),
            products: products,
            discount: 0,
            orderTotal: 0,
            subTotal: 0,
            cartSavedManually: false,
            cartSyncedToServer: CartSyncedToServerOnAuth.initial));
      } else if (authState is Authenticated) {
        final res = await cartRepository.getCartFromServer(currency,
            getStripeCoupon: false);
        return cartServerToStateMapper(res, emit);
      }
      // emit(state.copyWith(isCouponLoading: true, isTotalsLoading: true));
    });
//////////////////////////
    on<CartCalculateTotal>((event, emit) {
      emit(state.copyWith(
        cartTotal: state.products.entries.fold(
            0,
            (previousValue, element) =>
                previousValue + element.value.price * element.value.quantity),
      ));
    });
//////////////////////////
    on<CartSaveCartOnCheckout>(
      (event, emit) async {
        emit(state.copyWith(isTotalsLoading: true));

        if (authState is Authenticated) {
          final resp = await cartRepository.saveCartToServer(
              event.products, currency, false,
              getStripeCoupon: false);
          resp.fold(
              (l) {}, (r) => emit(state.copyWith(cartSavedManually: true)));
          return cartServerToStateMapper(resp, emit);
        } else if (authState is Unauthenticated) {}
      },
    );

    on<CartSaveCart>(
      (event, emit) async {
        emit(state.copyWith(isTotalsLoading: true));

        if (authState is Authenticated) {
          if (event.saveActionType == SaveActionType.save) {
            final resp = await cartRepository.saveCartToServer(
                event.products, event.currency, false,
                getStripeCoupon: false);
            return cartServerToStateMapper(resp, emit);
          } else if (event.saveActionType == SaveActionType.remove) {
            final resp = await cartRepository.removeItem(
                event.productCartModal.id, currency, false);
            return cartServerToStateMapper(resp, emit);
          }
        } else if (authState is Unauthenticated) {
          final newCartState = state.copyWith(
              isTotalsLoading: false,
              couponStateModal: state.couponStateModal,
              products: event.products,
              couponHasError: false,
              isLoading: false,
              isCouponLoading: false,
              cartTotal: event.products.entries.fold(
                  0,
                  (previousValue, element) =>
                      previousValue +
                      element.value.price * element.value.quantity));
          cartRepository.saveCartToLocal(newCartState.products);
          return emit(newCartState.copyWith(
            cartQuantity: state.products.entries.fold(
                0,
                (previousValue, element) =>
                    previousValue + element.value.quantity),
          ));
        }
      },
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .asyncExpand(mapper);
      },
    );

//////////////////////////
    on<AddItem>((event, emit) async {
      Map<String, ProductCartModal> products = {...state.products};
      if (state.products.containsKey(event.product.id)) {
        products.update(event.product.id,
            (value) => value.copyWith(quantity: value.quantity + 1));
      } else {
        products.addAll({event.product.id: event.product});
      }

      emit(state.copyWith(
        products: products,
        cartQuantity: state.cartQuantity + 1,
        cartTotal: products.entries.fold(
            0,
            (previousValue, element) =>
                previousValue + element.value.price * element.value.quantity),
      ));
      add(CartSaveCart(
          products: products,
          currency: currency,
          itemsPreLogin: false,
          saveActionType: SaveActionType.save,
          productCartModal: event.product));
      add(const CartEvent.calculateTotal());
    });
//////////////////////////
    on<AlterItem>((event, emit) async {
      Map<String, ProductCartModal> products = {...state.products};

      if (state.products.containsKey(event.product.id)) {
        switch (event.action) {
          case AlterItemAction.increment:
            products.update(event.product.id,
                (value) => value.copyWith(quantity: value.quantity + 1));

            add(CartSaveCart(
                products: products,
                currency: currency,
                itemsPreLogin: false,
                saveActionType: SaveActionType.save,
                productCartModal: event.product));
            break;
          case AlterItemAction.decrement:
            if (products[event.product.id]!.quantity > 1) {
              products.update(event.product.id,
                  (value) => value.copyWith(quantity: value.quantity - 1));
              add(CartSaveCart(
                  products: products,
                  currency: currency,
                  itemsPreLogin: false,
                  saveActionType: SaveActionType.save,
                  productCartModal: event.product));
            } else {
              products.remove(event.product.id);
              add(CartSaveCart(
                  products: products,
                  currency: currency,
                  itemsPreLogin: false,
                  saveActionType: SaveActionType.remove,
                  productCartModal: event.product));
              emit(state.copyWith(isLoading: true));
              // final resp =
              // await cartRepository.removeItem(event.product.id, currency,false);
              // return cartServerToStateMapper(resp, emit);
            }
            break;

          case AlterItemAction.delete:
            products.remove(event.product.id);
            emit(state.copyWith(isLoading: true));
            // add(CartSaveCart(
            //     products: products,
            //     currency: currency,
            //     itemsPreLogin: false,
            //     saveActionType: SaveActionType.remove,
            //     productCartModal: event.product));
            if (authState is Authenticated) {
              final resp = await cartRepository.removeItem(
                  event.product.id, currency, false);
              return cartServerToStateMapper(resp, emit);
            } else {
              cartRepository.saveCartToLocal(products);
              emit(state.copyWith(
                products: products,
                cartTotal: products.entries.fold(
                    0,
                    (previousValue, element) =>
                        previousValue +
                        element.value.price * element.value.quantity),
                cartQuantity: products.entries.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.value.quantity),
              ));
            }

            break;
        }
      }

      emit(state.copyWith(
        products: products,
        cartQuantity: products.entries.fold(0,
            (previousValue, element) => previousValue + element.value.quantity),
        cartTotal: products.entries.fold(
            0,
            (previousValue, element) =>
                previousValue + element.value.price * element.value.quantity),
      ));

      add(const CartEvent.calculateTotal());
    });

    on<CartClear>((event, emit) => emit(state.copyWith(
        cartQuantity: 0,
        cartTotal: 0.0,
        products: {},
        couponHasError: false,
        isLoading: false,
        couponStateModal: null,
        isCouponLoading: false)));
  }

  FutureOr<void> cartServerToStateMapper(
      Either<Failure, CartServerModal> res, Emitter<CartState> emit) {
    int quantity = 0;
    return res.fold((l) {
      // if (l is AccountHold) {
      //   authBloc.add(AuthEvent.logoutRequested());
      //   appControllerBloc.add(AppControllerEvent.setAppSnackBar(
      //       AppLevelSnackBar(
      //           message: "Your account is on hold, Please reset your password by clicking forgot password",
      //           duration: Duration(days: 360),
      //           showSnack: true)));
      // }
      Map<String, ProductCartModal> products = {};
      emit(CartState(
          cartSavedManually: false,
          isTotalsLoading: false,
          cartQuantity: quantity,
          cartTotal: 0.0,
          products: products,
          couponHasError: false,
          isLoading: false,
          isCouponLoading: false,
          discount: 0,
          orderTotal: 0,
          subTotal: 0,
          cartSyncedToServer: CartSyncedToServerOnAuth.initial));
    }, (serverCartData) async {
      Map<String, ProductCartModal> products = {};
      for (var item in serverCartData.products) {
        quantity = quantity + item.quantity;

        products[item.product.id] =
            item.product.toProductCartModalWithQuantity(item.quantity);
      }
      add(const CartEvent.calculateTotal());

      return emit(CartState(
          cartSyncedToServer: CartSyncedToServerOnAuth.initial,
          cartSavedManually: false,
          isTotalsLoading: false,
          cartQuantity: quantity,
          cartTotal: products.entries.fold(
              0,
              (previousValue, element) =>
                  previousValue + element.value.price * element.value.quantity),
          products: products,
          couponStateModal: serverCartData.coupon.isNotEmpty
              ? serverCartData.toCouponStateModal()
              : null,
          couponHasError: false,
          isLoading: false,
          isCouponLoading: false,
          discount: serverCartData.discount,
          orderTotal: serverCartData.orderTotal,
          subTotal: serverCartData.subTotal));
    });
  }
}
