import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/extensions/string_validator_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class ForgotPasswordInputWidget extends StatelessWidget {
  final TextEditingController emailController;
  final ValueChanged<String>? onEmailChanged;

  const ForgotPasswordInputWidget({
    super.key,
    required this.emailController,
    this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.45),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColor.orangeTint2,
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(
                  Icons.mail_outline_rounded,
                  color: AppColor.primary,
                  size: 18.r,
                ),
              ),
              10.wS,
              Expanded(
                child: Text(
                  'Reset Via Email',
                  style: AppFont.style(
                    color: AppColor.charcoal,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          14.hS,

          Divider(
            height: 1.h,
            thickness: 1.r,
            color: AppColor.border.withValues(alpha: 0.4),
          ),
          16.hS,

          // Email Label
          Row(
            children: [
              Text(
                'Email Address',
                style: AppFont.style(
                  color: AppColor.charcoal,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              2.wS,
              Text(
                '*',
                style: AppFont.style(
                  color: AppColor.bright_red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          6.hS,

          // Email Input Field
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: AppFont.style(
              color: AppColor.charcoal,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your email address';
              }
              if (!val.trim().isEmailValid) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter your registered email',
              hintStyle: AppFont.style(
                color: AppColor.slateGrey.withValues(alpha: 0.6),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColor.primary,
                size: 20.r,
              ),
              filled: true,
              fillColor: AppColor.whiteShade,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColor.border.withValues(alpha: 0.6),
                  width: 1.r,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColor.border.withValues(alpha: 0.6),
                  width: 1.r,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColor.primary,
                  width: 1.5.r,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColor.bright_red,
                  width: 1.r,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColor.bright_red,
                  width: 1.5.r,
                ),
              ),
              errorStyle: AppFont.style(
                color: AppColor.bright_red,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
