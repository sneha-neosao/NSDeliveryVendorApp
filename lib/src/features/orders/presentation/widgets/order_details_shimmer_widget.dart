import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OrderDetailsShimmerWidget extends StatelessWidget {
  const OrderDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: Column(
        children: [
          _buildCardShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(width: 110.w, height: 16.h, radius: 6.r),
                    _shimmerBox(width: 80.w, height: 24.h, radius: 12.r),
                  ],
                ),
                12.hS,
                _shimmerBox(width: 160.w, height: 12.h, radius: 4.r),
                8.hS,
                _shimmerBox(width: 140.w, height: 12.h, radius: 4.r),
              ],
            ),
          ),
          14.hS,
          _buildCardShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 130.w, height: 14.h, radius: 6.r),
                12.hS,
                Row(
                  children: [
                    _shimmerBox(width: 36.r, height: 36.r, radius: 18.r),
                    12.wS,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: 120.w, height: 14.h, radius: 4.r),
                        6.hS,
                        _shimmerBox(width: 90.w, height: 12.h, radius: 4.r),
                      ],
                    ),
                  ],
                ),
                12.hS,
                _shimmerBox(width: double.infinity, height: 12.h, radius: 4.r),
                6.hS,
                _shimmerBox(width: 200.w, height: 12.h, radius: 4.r),
              ],
            ),
          ),
          14.hS,
          _buildCardShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 110.w, height: 14.h, radius: 6.r),
                14.hS,
                Row(
                  children: [
                    _shimmerBox(width: 50.r, height: 50.r, radius: 10.r),
                    12.wS,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(width: 140.w, height: 14.h, radius: 4.r),
                          6.hS,
                          _shimmerBox(width: 70.w, height: 12.h, radius: 4.r),
                        ],
                      ),
                    ),
                    _shimmerBox(width: 50.w, height: 14.h, radius: 4.r),
                  ],
                ),
              ],
            ),
          ),
          14.hS,
          _buildCardShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 120.w, height: 14.h, radius: 6.r),
                12.hS,
                _buildBillRow(),
                8.hS,
                _buildBillRow(),
                8.hS,
                _buildBillRow(),
                12.hS,
                _shimmerBox(width: double.infinity, height: 1.h, radius: 1.r),
                12.hS,
                _buildBillRow(isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardShimmer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.6),
          width: 1.r,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColor.border.withValues(alpha: 0.35),
        highlightColor: AppColor.pureWhite,
        child: child,
      ),
    );
  }

  Widget _buildBillRow({bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _shimmerBox(
          width: isTotal ? 90.w : 110.w,
          height: isTotal ? 16.h : 12.h,
          radius: 4.r,
        ),
        _shimmerBox(
          width: isTotal ? 70.w : 50.w,
          height: isTotal ? 16.h : 12.h,
          radius: 4.r,
        ),
      ],
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
