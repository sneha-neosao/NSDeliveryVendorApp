import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OffersShimmerWidget extends StatelessWidget {
  final int itemCount;

  const OffersShimmerWidget({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 14.h,
        bottom: 16.h,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) => 14.hS,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColor.border.withValues(alpha: 0.4),
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row: Badge + Status Pill ─────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 110.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: AppColor.whiteShade,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    Container(
                      width: 65.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: AppColor.whiteShade,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ],
                ),

                12.hS,

                // ── Discount Title Placeholder ───────────────────────
                Container(
                  width: 160.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColor.whiteShade,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),

                8.hS,

                // ── Description Placeholder ──────────────────────────
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: AppColor.whiteShade,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),

                12.hS,

                // ── Divider ──────────────────────────────────────────
                Container(
                  height: 1.h,
                  color: AppColor.whiteShade,
                ),

                12.hS,

                // ── Bottom Stats Row ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColor.whiteShade,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      width: 80.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColor.whiteShade,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Container(
                      width: 90.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColor.whiteShade,
                        borderRadius: BorderRadius.circular(4.r),
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
