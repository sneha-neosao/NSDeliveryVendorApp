import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_color.dart';

class StoreAvatarWidget extends StatelessWidget {
  final double? size;

  const StoreAvatarWidget({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? 82.r;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(10.r),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.orangeTint2.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: Icon(
              Icons.storefront_rounded,
              color: AppColor.primary,
              size: 42.r,
            ),
          ),
        ),
      ),
    );
  }
}
