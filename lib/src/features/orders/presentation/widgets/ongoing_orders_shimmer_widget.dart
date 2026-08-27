import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OngoingOrdersShimmerWidget extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const OngoingOrdersShimmerWidget({
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
      separatorBuilder: (_, _) => 14.hS,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColor.border.withValues(alpha: 0.35),
          highlightColor: AppColor.pureWhite,
          child: Container(
            padding: EdgeInsets.all(14.r),
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
                // Row 1: Icon + Order ID + Status chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.pureWhite,
                          ),
                        ),
                        8.wS,
                        Container(
                          width: 100.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ],
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
                // Divider
                Container(
                  height: 1.h,
                  color: AppColor.border.withValues(alpha: 0.3),
                ),
                10.hS,
                // Row 2: Customer name + Grand total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer name
                        Container(
                          width: 140.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        6.hS,
                        // Payment mode + items
                        Container(
                          width: 110.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ],
                    ),
                    // Grand total
                    Container(
                      width: 60.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
                12.hS,
                // Row 3: Payment status badge + Action button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    Container(
                      width: 110.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(14.r),
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
