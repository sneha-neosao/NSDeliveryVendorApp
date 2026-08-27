import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OrderHistoryShimmerWidget extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const OrderHistoryShimmerWidget({
    super.key,
    this.itemCount = 5,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h);

    return ListView.separated(
      padding: effectivePadding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => 12.hS,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColor.border.withValues(alpha: 0.35),
          highlightColor: AppColor.pureWhite,
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: AppColor.border.withValues(alpha: 0.6),
                width: 1.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Order ID + Status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    Container(
                      width: 70.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ],
                ),
                10.hS,
                // Row 2: Customer name
                Container(
                  width: 140.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: AppColor.pureWhite,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                8.hS,
                // Row 3: Amount + items
                Row(
                  children: [
                    Container(
                      width: 70.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    12.wS,
                    Container(
                      width: 60.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
                8.hS,
                // Row 4: Payment mode + date
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    12.wS,
                    Container(
                      width: 120.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
