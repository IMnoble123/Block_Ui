import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:net_carbons/app/auth/auth_bloc.dart';
import 'package:net_carbons/domain/user_profile/modal/profile_modal.dart';
import 'package:net_carbons/presentation/app_widgets/outlined_button.dart';
import 'package:net_carbons/presentation/calculate_page/bloc/calculate_bloc.dart';
import 'package:net_carbons/presentation/cart/bloc/cart_bloc.dart';
import 'package:net_carbons/presentation/checkout/bloc/checkout_bloc.dart';
import 'package:net_carbons/presentation/resources/color.dart';

import '../../app/constants/string_constants.dart';
import '../layout_screen/main_screen.dart';
import '../register/registration_otp_verification.dart';
import '../resources/route_manager.dart';
import 'checkout_views/address_page_view.dart';
import 'checkout_views/payment_page_view.dart';

ValueNotifier<int> checkoutSelectedPageNotifier = ValueNotifier(0);

class ScreenCheckout extends StatefulWidget {
  const ScreenCheckout({
    super.key,
  });

  @override
  State<ScreenCheckout> createState() => _ScreenCheckoutState();
}

class _ScreenCheckoutState extends State<ScreenCheckout> {
  BillingAddressModal? _billingAddressModal;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    checkoutSelectedPageNotifier.value = 0;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool firstBuild = true;
  @override
  Widget build(BuildContext context) {
    print("wlcome chckout");
    return WillPopScope(
      onWillPop: () async {
        print("Good by chckout");

        BlocProvider.of<CheckoutBloc>(context).add(const CheckoutEvent.done());
        return true;
      },
      child: Scaffold(
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, checkOutState) {
            // TODO: implement listener
          },
          builder: (context, checkOutState) {
            if (!checkOutState.isLoading &&
                checkOutState.userProfile == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Oops!! Failed to load your profile",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      AppButton(
                        filled: true,
                        text: Text(
                          "Reload",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        onTap: () {
                          BlocProvider.of<CheckoutBloc>(context)
                              .add(const CheckoutEvent.updateUser());
                        },
                        feedbackTimeText: Text(
                          "Reload",
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(
                              color: AppColors.primaryActiveColor),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      AppButton(
                        onTap: () {
                          BlocProvider.of<CheckoutBloc>(context)
                              .add(const CheckoutEvent.done());
                          Navigator.pop(context);
                        },
                        text: Text(
                          "Go Back",
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(
                              color: AppColors.primaryActiveColor),
                        ),
                        feedbackTimeText: Text(
                          "Go Back",
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(color: AppColors.appWhite),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (checkOutState.onSession &&
                checkOutState.userProfile != null) {
              if (checkOutState.billingAddress != null) {
                if (checkOutState.userProfile!.user.email.isNotEmpty) {
                  if (checkOutState.checkoutType == CheckoutType.express) {
                    checkoutSelectedPageNotifier.value = 1;
                  }
                }
              }
              // });
              return ModalProgressHUD(
                progressIndicator: const CupertinoActivityIndicator(
                  color: Colors.amber,
                ),
                inAsyncCall: checkOutState.isLoading ||
                    checkOutState.isCouponLoading,
                child: ValueListenableBuilder(
                  // physics: const NeverScrollableScrollPhysics(),
                  // controller: _pageController,
                  valueListenable: checkoutSelectedPageNotifier,
                  builder:
                      (BuildContext context, int value, Widget? child) {
                    return value == 0
                        ? InputAddressPageView(
                      onSubmit: onSubmitAddress,
                      profileModalData: checkOutState.userProfile!,
                      billingAddressModal:
                      checkOutState.billingAddress,
                    )
                        : ConfirmPaymentView();
                  },
                ),
              );
            } else {
              return const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.green,
                  ));
            }
          },
        ),
      ),
    );
  }

  void onSubmitAddress(BillingAddressModal billingAddressModal) async {
    BlocProvider.of<CheckoutBloc>(context)
        .add(CheckoutEvent.billingAddressUpdate(billingAddressModal));

    checkoutSelectedPageNotifier.value = 1;
  }
}
