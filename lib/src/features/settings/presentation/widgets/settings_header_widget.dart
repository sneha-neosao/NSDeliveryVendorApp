import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_color.dart';

class SettingsHeaderWidget extends StatelessWidget {
  final VoidCallback? onBackTap;

  const SettingsHeaderWidget({
    super.key,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Back Button
        GestureDetector(
          onTap: onBackTap ?? () => context.pop(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.pureWhite.withValues(alpha: 0.18),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.pureWhite,
              size: 18.r,
            ),
          ),
        ),
        // Centered Profile Title
        Expanded(
          child: Text(
            'Profile',
            textAlign: TextAlign.center,
            softWrap: true,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColor.pureWhite,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        // Right Balancer to ensure true centering
        SizedBox(width: 38.r),
      ],
    );
  }
}
