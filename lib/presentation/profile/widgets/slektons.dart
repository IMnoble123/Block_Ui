import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:net_carbons/presentation/profile/widgets/profile_list_items.dart';
import 'package:net_carbons/presentation/resources/assets.dart';
import 'package:net_carbons/presentation/resources/ui_widgets/shimmer_container.dart';

class ProfilePageSkeleton extends StatelessWidget {
  const ProfilePageSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyShimmerContainer(
      child: ListView(
        children: [
          Container(
            height: 54.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Container(),
          ),
          SizedBox(
            height: 40.h,
          ),
          ProfileListItem(
            icon: SvgPicture.asset(SvgAssets.earth),
            text: "My dashboard",
            onTap: () {},
          ),
          ProfileListItem(
            icon: SvgPicture.asset(SvgAssets.cartIcon),
            text: "My Orders",
            onTap: () {},
          ),
          ProfileListItem(
            icon: SvgPicture.asset(SvgAssets.personIconActive),
            text: "My Profile",
            onTap: () {},
          ),
          ProfileListItem(
              icon: const Icon(Icons.key),
              text: "Change Password",
              onTap: () {}),
          ProfileListItem(
              icon: const Icon(Icons.location_city),
              text: "Change Address",
              onTap: () async {}),
          ProfileListItem(
            icon: const Icon(Icons.settings),
            text: "Settings",
            onTap: () {},
          ),
          ProfileListItem(
            icon: SvgPicture.asset(SvgAssets.agreement),
            text: "User Agreement",
            onTap: () {},
          ),
          ProfileListItem(
            icon: SvgPicture.asset(SvgAssets.logout),
            text: "Log out",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class OrderListSkeleton extends StatelessWidget {
  const OrderListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyShimmerContainer(
      child: SingleChildScrollView(
        child: Column(
          children: const [
            MyOrderListItemSkeleton(),
            MyOrderListItemSkeleton(),
            MyOrderListItemSkeleton(),
          ],
        ),
      ),
    );
  }
}

class MyOrderListItemSkeleton extends StatelessWidget {
  const MyOrderListItemSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: 22.w, right: 22.w, top: 12.h, bottom: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.green,
                width: 157.w,
                height: 18.h,
              ),
              Container(
                color: Colors.black,
                width: 157.w,
                height: 18.h,
              ),
            ],
          ),
          SizedBox(
            height: 21.h,
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 106.h,
                    width: 106.h,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 13.w,
                  ),
                  Container(
                    height: 106.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: Colors.red,
                          width: 200.w,
                          height: 24.h,
                        ),
                        SizedBox(
                          height: 9.h,
                        ),
                        Container(
                          color: Colors.red,
                          width: 160.w,
                          height: 19.h,
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        Container(
                          color: Colors.black,
                          width: 73.w,
                          height: 24.h,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 21.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.black,
                width: 120.w,
                height: 22.h,
              ),
              Container(
                color: Colors.black,
                width: 100.w,
                height: 22.h,
              ),
            ],
          ),
          SizedBox(
            height: 13.h,
          ),
          Container(
            color: Colors.black,
            height: 43.h,
          ),
        ],
      ),
    );
  }
}
