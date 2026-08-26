import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_color.dart';

/// Right-aligned forgot password action button.
class AuthForgotPasswordWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const AuthForgotPasswordWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            'Forgot Password?',
            softWrap: true,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColor.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
