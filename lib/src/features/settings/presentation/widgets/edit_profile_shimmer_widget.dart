import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

/// Shimmer placeholder displayed while fetching profile details on Edit Profile screen.
class EditProfileShimmerWidget extends StatelessWidget {
  const EditProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.6),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppColor.border.withValues(alpha: 0.35),
        highlightColor: AppColor.pureWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldPlaceholder(labelWidth: 80.w),
            16.hS,
            _buildFieldPlaceholder(labelWidth: 100.w),
            16.hS,
            _buildFieldPlaceholder(labelWidth: 80.w),
            16.hS,
            _buildFieldPlaceholder(labelWidth: 110.w),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldPlaceholder({required double labelWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label bar
        Container(
          width: labelWidth,
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        6.hS,
        // Text field container bar
        Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    );
  }
}
