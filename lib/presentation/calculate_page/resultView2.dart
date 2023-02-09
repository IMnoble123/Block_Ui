import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:net_carbons/app/app_controller/app_controller_bloc.dart';
import 'package:net_carbons/app/auth/auth_bloc.dart';
import 'package:net_carbons/app/constants/string_constants.dart';
import 'package:net_carbons/app/util_functions/getPriceFormatted.dart';
import 'package:net_carbons/domain/cart/models/cart_modal.dart';
import 'package:net_carbons/domain/home_products/modal/models.dart';
import 'package:net_carbons/presentation/calculate_page/bloc/calculate_bloc.dart';
import 'package:net_carbons/presentation/cart/bloc/cart_bloc.dart';
import 'package:net_carbons/presentation/checkout/bloc/checkout_bloc.dart';
import 'package:net_carbons/presentation/home-products/bloc/products_bloc.dart';
import 'package:net_carbons/presentation/layout_screen/main_screen.dart';
import 'package:net_carbons/presentation/layout_screen/widgets/bottom_bar.dart';
import 'package:net_carbons/presentation/register/registration_otp_verification.dart';
import 'package:net_carbons/presentation/resources/ui_widgets/top_wave.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../app_widgets/outlined_button.dart';
import '../resources/color.dart';
import '../resources/route_manager.dart';
import 'calculate_page.dart';

class ResultView2 extends StatelessWidget {
  const ResultView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppControllerBloc, AppControllerState>(
      builder: (context, appState) {
        return BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, productsState) {
            if (productsState.products.isEmpty) {
              BlocProvider.of<ProductsBloc>(context)
                  .add(ProductsEvent.fetchProducts());
            }
            List products = [...productsState.products];
            products.sort((a, b) =>
                a.priceList.first.price.compareTo(b.priceList.first.price));
            if (products.isNotEmpty) {
              BlocProvider.of<CalculateBloc>(context)
                  .add(CalculateEvent.getLeastProduct(products.first));
            }

            return BlocBuilder<CalculateBloc, CalculateState>(
              builder: (context, calculateState) {
                final total = calculateState.offsetValue *
                    (calculateState
                            .productWithLeastPrice
                            //TODO: price list
                            .priceLocal
                            ?.price ??
                        calculateState.productWithLeastPrice.priceInUsd.price);
                return ModalProgressHUD(
                  inAsyncCall: productsState.isLoading,
                  progressIndicator: const CupertinoActivityIndicator(),
                  child: Scaffold(
                    appBar: buildAppAppBar(() {
                      calculatorSelectedPageNotifier.value = 0;
                    }),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 28.w),
                                  child: Text(
                                    "Choose amount or tons",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.copyWith(
                                            letterSpacing: .1, fontSize: 28.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 28.h),
                                SleekCircularSlider(
                                  onChangeStart: (val) {},
                                  onChangeEnd: (val) {},
                                  max: 101,
                                  min: 0,
                                  initialValue: calculateState
                                      .percentageSliderValue
                                      .floor()
                                      .toDouble(),
                                  onChange: (newVal) {
                                    // setState(() {
                                    //   //   endAngle = (newVal / 100) * 360;
                                    // });

                                    BlocProvider.of<CalculateBloc>(context).add(
                                        CalculateEvent.percentageSliderChanged(
                                            newVal.floor().toDouble()));
                                  },
                                  appearance: CircularSliderAppearance(
                                    angleRange: 360,
                                    startAngle: 270,
                                    size: 330.r,
                                    customWidths: CustomSliderWidths(
                                        shadowWidth: 50,
                                        trackWidth: 35.r,
                                        progressBarWidth: 35.r,
                                        handlerSize: 18.r),
                                    customColors: CustomSliderColors(
                                      progressBarColors:
                                          AppColors.progressBarColors,
                                      trackColors: [
                                        AppColors.redAccent,
                                        AppColors.redAccent1
                                      ],
                                      gradientStartAngle: -90,
                                      gradientEndAngle: 90,
                                      hideShadow: true,
                                    ),
                                    spinnerMode: false,
                                  ),
                                  innerWidget: (val) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Stack(
                                          children: [
                                            ArchText1(
                                              productWithLeastPrice:
                                                  calculateState
                                                      .productWithLeastPrice,
                                              calculatorResultValue:
                                                  calculateState
                                                      .calculatorResultValue,
                                              totalValue:
                                                  calculateState.totalValue,
                                            ),
                                            Center(
                                              child: SizedBox(
                                                width: 200.r,
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      SizedBox(
                                                        width: 230.r,
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: Text(
                                                            getPriceFormattedWithCODE(
                                                                appState
                                                                    .currency,
                                                                total),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline1
                                                                ?.copyWith(
                                                                  color: AppColors
                                                                      .primaryActiveColor,
                                                                ),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              children: [
                                                            TextSpan(
                                                                text: calculateState
                                                                    .offsetValue
                                                                    .toStringAsFixed(
                                                                        0),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline1
                                                                    ?.copyWith(
                                                                      color: AppColors
                                                                          .greenAccent2,
                                                                    )),
                                                            TextSpan(
                                                                text: ' Tons',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline1
                                                                    ?.copyWith(
                                                                        color: AppColors
                                                                            .greenAccent1)),
                                                          ])),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 28.w),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        // Text(
                                        //   "Product Selected : ${calculateState
                                        //       .productWithLeastPrice
                                        //       .name}",
                                        //   style:
                                        //       Theme.of(context).textTheme.headline2?.copyWith(color: AppColors.primaryActiveColor),
                                        // ),
                                        Text(
                                          "Product Selected",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              ?.copyWith(
                                                  color: AppColors
                                                      .primaryActiveColor,
                                                  fontSize: 16.sp),
                                        ),
                                        SizedBox(
                                          height: 13.h,
                                        ),
                                        Text(
                                          calculateState
                                              .productWithLeastPrice.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              ?.copyWith(
                                                  color: AppColors
                                                      .primaryActiveColor,
                                                  fontSize: 16.sp),
                                        ),
                                        SizedBox(
                                          height: 13.h,
                                        ),
                                        RichText(
                                            overflow: TextOverflow.visible,
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: calculateState
                                                          .productWithLeastPrice
                                                          .country),
                                                  const TextSpan(text: " "),
                                                  TextSpan(
                                                      text: calculateState
                                                          .productWithLeastPrice
                                                          .category),
                                                  const TextSpan(text: " - "),
                                                  TextSpan(
                                                      text: calculateState
                                                          .productWithLeastPrice
                                                          .productType),
                                                  const TextSpan(text: " - "),
                                                  TextSpan(
                                                      //TODO:PRICE list
                                                      text:
                                                          "${appState.currency} ${getPriceFormattedWithoutcode(appState.currency, calculateState.productWithLeastPrice.priceLocal?.price ?? calculateState.productWithLeastPrice.priceInUsd.price)}"),
                                                ],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .appGreyColor))),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 11.w, vertical: 16.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AppButton(
                                  height: 60.h,
                                  onTap: () {
                                    selectedIndexNotifier.value = 0;
                                  },
                                  text: Text(
                                    ButtonStrings.chooseProducts,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                          color: AppColors.primaryActiveColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                  filled: false,
                                  feedbackTimeText: Text(
                                    ButtonStrings.chooseProducts,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                          color: AppColors.appWhite,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: AppButton(
                                  height: 60.h,
                                  filled: true,
                                  onTap: () async {
                                    if (calculateState.offsetValue.toInt() <
                                        1) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please specify offset with dial")));
                                      return;
                                    }
                                    final authState =
                                        BlocProvider.of<AuthBloc>(context)
                                            .state;
                                    _initiateCheckOut(
                                        context, authState, calculateState);
                                  },
                                  text: Text(ButtonStrings.buyNow,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          ?.copyWith(
                                            letterSpacing: .1,
                                            color: AppColors.appWhite,
                                          )),
                                  padding: EdgeInsets.all(12.w),
                                  feedbackTimeText: Text(ButtonStrings.buyNow,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          ?.copyWith(
                                            letterSpacing: .1,
                                            color: AppColors.primaryActiveColor,
                                          )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _initiateCheckOut(BuildContext context, AuthState authState,
      CalculateState calculateState) {
    BlocProvider.of<CheckoutBloc>(context).add(CheckoutEvent.started(
        productCartModal: calculateState.productWithLeastPrice
            .toProductCartModalWithQuantity(calculateState.offsetValue.toInt()),
        checkoutType: CheckoutType.express));

    if (authState is Authenticated) {
      if (authState.authDataModal.user.emailVerificationStatus !=
          VerifyStatusEum.VERIFIED.name) {
        Navigator.pushNamed(context, Routes.screenRegistrationEnterOtp,
                arguments: OtpVerificationArguments(
                    authState.authDataModal.user.email, Routes.checkoutScreen))
            .then((value) {
          if (value == VerifyStatusEum.VERIFIED) {
            Navigator.pushNamed(mainScaffold.currentContext ?? context,
                    Routes.checkoutScreen)
                .then((value) {
              BlocProvider.of<CartBloc>(mainScaffold.currentContext ?? context)
                  .add(const CartEvent.cartStarted());
            });
          } else {
            Navigator.pop(context);
          }
        });
      } else if (authState.authDataModal.user.emailVerificationStatus ==
          VerifyStatusEum.VERIFIED.name) {
        Navigator.pushNamed(
                mainScaffold.currentContext ?? context, Routes.checkoutScreen)
            .then((value) {
          BlocProvider.of<CartBloc>(mainScaffold.currentContext ?? context)
              .add(const CartEvent.cartStarted());
        });
      }
    } else {
      Navigator.pushNamed(
        context,
        Routes.screenYouAreNotSignedIn,
      ).then((value) {
        if (value == VerifyStatusEum.VERIFIED) {
          Navigator.pushNamed(
                  mainScaffold.currentContext ?? context, Routes.checkoutScreen)
              .then((value) {
            ///TODO: if error occures make to scaffold key
            BlocProvider.of<CartBloc>(mainScaffold.currentContext ?? context)
                .add(const CartEvent.cartStarted());
          });
        } else {
          Navigator.pop(context);
        }
      });
    }
  }

  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 6) {
      args.cancel = true;
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  // void handleCardPointerValueChanged(double value) {
  //   BlocProvider.of<CalculateBloc>(context)
  //       .add(CalculateEvent.percentageSliderChanged(value));
  //   // setState(() {
  //   //   _cardCurrentValue = value.roundToDouble();
  //   //   final int cardCurrentValue = _cardCurrentValue.toInt();
  //   //   _cardAnnotationValue = '$cardCurrentValue';
  //   //   _cardMarkerValue = _cardCurrentValue - 2;
  //   // });
  // }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleCardPointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 6) {
      args.cancel = true;
    }
  }
}

class ArchText1 extends StatelessWidget {
  const ArchText1({
    Key? key,
    this.calculatorResultValue,
    this.totalValue,
    required this.productWithLeastPrice,
  }) : super(key: key);
  final double? calculatorResultValue;
  final double? totalValue;
  final ProductModal productWithLeastPrice;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularText(
        children: [
          TextItem(
            text: Text(
              "My Co2 Footprint:${calculatorResultValue?.roundToDouble().toStringAsFixed(2)} Tons",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: AppColors.appGreyColor, fontSize: 14.sp),
            ),
            space: 5,
            startAngle: -90,
            startAngleAlignment: StartAngleAlignment.center,
            direction: CircularTextDirection.clockwise,
          ),
          TextItem(
            text: Text(
                "Cost to Reduce 100%:${productWithLeastPrice.priceLocal?.currency ?? productWithLeastPrice.priceInUsd.currency}${getPriceFormattedWithoutcode(productWithLeastPrice.priceLocal?.currency ?? productWithLeastPrice.priceInUsd.currency, totalValue ?? 0)}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: AppColors.appGreyColor, fontSize: 14.sp)),
            space: 5,
            startAngle: 90,
            startAngleAlignment: StartAngleAlignment.center,
            direction: CircularTextDirection.anticlockwise,
          ),
        ],
        radius: 124.r,
        position: CircularTextPosition.inside,
      ),
    );
  }
}
