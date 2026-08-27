import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class SlotShimmerWidget extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const SlotShimmerWidget({
    super.key,
    this.itemCount = 6,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h);

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
                // Row 1: Day of week + Status chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36.r,
                          height: 36.r,
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        10.wS,
                        Container(
                          width: 110.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 65.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ],
                ),
                12.hS,

                // Divider
                Container(
                  height: 1.h,
                  color: AppColor.border.withValues(alpha: 0.3),
                ),
                12.hS,

                // Row 2: Time Box placeholder
                Container(
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColor.pureWhite,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
