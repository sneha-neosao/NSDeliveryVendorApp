import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_color.dart';

/// Primary action button for submitting login credentials.
class AuthLoginButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const AuthLoginButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Login',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          disabledBackgroundColor: AppColor.primary.withValues(alpha: 0.6),
          foregroundColor: AppColor.pureWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.pureWhite),
                ),
              )
            : Text(
                text,
                softWrap: true,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColor.pureWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
      ),
    );
  }
}
