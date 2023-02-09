import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_carbons/app/util_functions/getPriceFormatted.dart';
import 'package:net_carbons/domain/home_products/modal/models.dart';
import 'package:net_carbons/presentation/resources/assets.dart';
import 'package:net_carbons/presentation/resources/color.dart';
import 'package:net_carbons/presentation/wish_list/bloc/wish_list_bloc.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final ProductModal product;

  @override
  Widget build(BuildContext context) {
    var cardHeight = 213.h;
    final isInWishList = BlocProvider.of<WishListBloc>(context)
        .state
        .items
        .any((element) => element.id == product.id);
    final calculatedDiscount = percentageDifference(
      oldPrice: product.priceLocal?.oldPrice ?? product.priceInUsd.oldPrice,
      newPrice: product.priceLocal?.price ?? product.priceInUsd.price,
    );
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
          border: Border.all(color: AppColors.productCardBorder)),
      height: cardHeight,
      child: Stack(
        children: <Widget>[
          Container(
            height: cardHeight,
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(product.thumbImage.first))),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 101.h,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [
                        0.0,
                        0.2,
                        0.3,
                        0.8,
                      ],
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(.1),
                        Colors.white.withOpacity(.5),
                        Colors.white,
                      ],
                    ),
                    image: const DecorationImage(
                        opacity: .5,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(ImageAssets.productWave))),
                child: Padding(
                  padding: EdgeInsets.only(left: 13.w, right: 13.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 28.h,
                      ),
                      SizedBox(
                        child: Text(
                          product.name,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  height: 1.2,
                                  color: AppColors.primaryActiveColor),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ("${product.priceLocal?.currency ?? product.priceInUsd.currency} "),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                      color: AppColors.primaryActiveColor),
                            ),
                            Text(
                              getPriceFormattedWithoutcode(
                                  product.priceLocal?.currency ??
                                      product.priceInUsd.currency,
                                  product.priceLocal?.oldPrice ??
                                      product.priceInUsd.oldPrice),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                      color: AppColors.appGreyColor,
                                      decoration: TextDecoration.lineThrough),
                            ),
                            Text(
                              " / ${getPriceFormattedWithoutcode(product.priceLocal?.currency ?? product.priceInUsd.currency, product.priceLocal?.price ?? product.priceInUsd.price)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                      color: AppColors.primaryActiveColor),
                            ),
                          ]),
                      SizedBox(
                        height: 3.h,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.w,
                              height: 10.w,
                              child: SvgPicture.asset(
                                SvgAssets.locationFilled,
                                color: AppColors.primaryActiveColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              product.country,
                              style: GoogleFonts.workSans(
                                  fontWeight: FontWeight.w400, fontSize: 12.sp),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Positioned(
            bottom: 70.h,
            right: 12.w,
            child: GestureDetector(
              onTap: () {
                isInWishList
                    ? BlocProvider.of<WishListBloc>(context)
                        .add(WishListEvent.removeItem(product: product))
                    : BlocProvider.of<WishListBloc>(context)
                        .add(WishListEvent.addItem(product: product));
              },
              child: SizedBox(
                width: 36.w,
                height: 36.w,
                child: CircleAvatar(
                  radius: 26.sp,
                  backgroundColor: AppColors.appWhite.withOpacity(.83),
                  child: Center(
                    child: isInWishList
                        ? SvgPicture.asset(
                            SvgAssets.favIconFilled,
                            width: 20.w,
                          )
                        : SvgPicture.asset(
                            SvgAssets.favIcon,
                            width: 20.w,
                          ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 13.w,
            bottom: 15.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.cover,
                          image: AssetImage(ImageAssets.americanCarbonReg))),
                  width: 50.w,
                  height: 20.h,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Renewable Energy",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: AppColors.primaryActiveColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 10.h,
            child: Container(
              padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calculatedDiscount != 0
                      ? SizedBox(
                          width: 36.w,
                          height: 36.w,
                          child: CircleAvatar(
                            backgroundColor: AppColors.discountAvatarColor,
                            radius: 26.sp,
                            child: Center(
                              child: Text(
                                '${calculatedDiscount.toStringAsFixed(0)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        color: AppColors.appWhite,
                                        fontSize: 12.sp),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 8.h,
                  ),
                  product.tag.any((element) => element == 'new')
                      ? SizedBox(
                          width: 36.w,
                          height: 36.w,
                          child: CircleAvatar(
                            radius: 26.sp,
                            backgroundColor: AppColors.cherryRed,
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                "New",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        color: AppColors.appWhite,
                                        fontSize: 12.sp),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  double percentageDifference(
      {required double oldPrice, required double newPrice}) {
    return 100 - (100 / oldPrice) * newPrice;
  }
}
