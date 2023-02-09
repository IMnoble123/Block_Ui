import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:net_carbons/presentation/resources/color.dart';
import 'package:net_carbons/presentation/single_product_page/bloc/product_details_bloc.dart';

import 'expanded_review.dart';

class ReviewBuilder extends StatelessWidget {
  ReviewBuilder({
    Key? key,
    required this.productId,
    required this.state,
  }) : super(key: key);
  final String productId;
  final ProductDetailsState state;

  @override
  Widget build(BuildContext context) {
    return state.currentProductReviews.isEmpty
        ? const Center(
            child: Text("No Reviews"),
          )
        : ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => ExpandedReviews(
                  reviewModal: state.currentProductReviews[index],
                ),
            separatorBuilder: (context, index) => Divider(
                  color: AppColors.lightGrey,
                  thickness: 1.h,
                ),
            itemCount: state.currentProductReviews.length);
  }
}
