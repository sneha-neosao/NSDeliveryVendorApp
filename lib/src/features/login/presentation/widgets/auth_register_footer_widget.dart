import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_color.dart';

/// Bottom footer prompt leading to the registration screen.
class AuthRegisterFooterWidget extends StatelessWidget {
  final VoidCallback? onRegisterTap;

  const AuthRegisterFooterWidget({
    super.key,
    this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onRegisterTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          child: RichText(
            textAlign: TextAlign.center,
            softWrap: true,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.5.sp,
                  ),
              children: [
                TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: AppColor.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Register',
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
