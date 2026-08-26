import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

/// Section header displaying the greeting and subtitle instructions.
class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeaderWidget({
    super.key,
    this.title = 'Welcome Back!',
    this.subtitle = 'Login to continue',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColor.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
        ),
        6.hS,
        Text(
          subtitle,
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColor.textSecondary,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
