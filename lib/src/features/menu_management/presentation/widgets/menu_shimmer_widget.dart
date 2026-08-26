import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class MenuShimmerWidget extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const MenuShimmerWidget({
    super.key,
    this.itemCount = 6,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          top: 6.h,
          bottom: 100.h,
        );

    return ListView.separated(
      padding: effectivePadding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) => 12.hS,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColor.border.withValues(alpha: 0.35),
          highlightColor: AppColor.pureWhite,
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColor.border.withValues(alpha: 0.6),
                width: 1.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left Column: Details ─────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Diet badge + category pill
                      Row(
                        children: [
                          Container(
                            width: 15.r,
                            height: 15.r,
                            decoration: BoxDecoration(
                              color: AppColor.pureWhite,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          8.wS,
                          Container(
                            width: 68.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColor.pureWhite,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),

                      8.hS,

                      // Item Name
                      Container(
                        width: 160.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: AppColor.pureWhite,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),

                      6.hS,

                      // Price + Rating + Prep Time
                      Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColor.pureWhite,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          10.wS,
                          Container(
                            width: 38.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColor.pureWhite,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          10.wS,
                          Container(
                            width: 38.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: AppColor.pureWhite,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ],
                      ),

                      8.hS,

                      // Description lines
                      Container(
                        width: double.infinity,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColor.pureWhite,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      4.hS,
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
                ),

                14.wS,

                // ── Right Column: Image & Stock Badge ────────
                Column(
                  children: [
                    Container(
                      width: 86.r,
                      height: 86.r,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    8.hS,
                    Container(
                      width: 58.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(8.r),
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
