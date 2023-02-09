import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:net_carbons/presentation/cart/bloc/cart_bloc.dart';
import 'package:net_carbons/presentation/layout_screen/main_screen.dart';
import 'package:net_carbons/presentation/resources/assets.dart';
import 'package:net_carbons/presentation/resources/color.dart';
import 'package:net_carbons/presentation/wish_list/bloc/wish_list_bloc.dart';

class CartWishlistBar extends StatelessWidget {
  const CartWishlistBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishListBloc, WishListState>(
      builder: (context, wishListState) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return Builder(
              builder: (context) => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.all(4.w),
                            width: 24.h,
                            height: 24.h,
                            child: SvgPicture.asset(SvgAssets.favIcon)),
                        onTap: () {
                          mainScaffold.currentState?.openDrawer();
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                      wishListState.items.isNotEmpty? Positioned(
                        right: 0.w,
                        top: 0.w,
                        child: CircleAvatar(
                          backgroundColor: AppColors.cherryRed,
                          radius: 8.r,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(wishListState.items.length.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800)),
                            ),
                          ),
                        ),
                      ):SizedBox()
                    ],
                  ),
                  SizedBox(
                    width: 18.w,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                            margin: EdgeInsets.all(4.w),
                            width: 24.h,
                            height: 24.h,
                            child: SvgPicture.asset(SvgAssets.cartIcon)),
                        onTap: () {
                          print("object");
                          mainScaffold.currentState?.openEndDrawer();
                        },
                      ),
                      cartState.cartQuantity == 0
                          ? SizedBox()
                          : Positioned(
                              right: 0.w,
                              top: 0.w,
                              child: CircleAvatar(
                                backgroundColor: AppColors.cherryRed,
                                radius: 8.r,
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                        cartState.cartQuantity.toString(),
                                        overflow: TextOverflow.visible,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800)),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
