import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import 'change_password_textfield_widget.dart';

class ChangePasswordInputWidget extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String>? onOldPasswordChanged;
  final ValueChanged<String>? onNewPasswordChanged;
  final ValueChanged<String>? onConfirmPasswordChanged;

  const ChangePasswordInputWidget({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    this.onOldPasswordChanged,
    this.onNewPasswordChanged,
    this.onConfirmPasswordChanged,
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
          // Section Subtitle
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
                  Icons.shield_outlined,
                  color: AppColor.primary,
                  size: 18.r,
                ),
              ),
              10.wS,
              Expanded(
                child: Text(
                  'Account Security',
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

          // 1. Old Password Field
          ChangePasswordTextField(
            label: 'Old Password',
            hintText: 'Enter your current password',
            prefixIcon: Icons.lock_clock_outlined,
            controller: oldPasswordController,
            onChanged: onOldPasswordChanged,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your current password';
              }
              return null;
            },
          ),
          16.hS,

          // 2. New Password Field
          ChangePasswordTextField(
            label: 'New Password',
            hintText: 'Enter your new password',
            prefixIcon: Icons.lock_outline_rounded,
            controller: newPasswordController,
            onChanged: onNewPasswordChanged,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter a new password';
              }
              if (val.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          16.hS,

          // 3. Confirm Password Field
          ChangePasswordTextField(
            label: 'Confirm Password',
            hintText: 'Re-enter your new password',
            prefixIcon: Icons.lock_reset_rounded,
            controller: confirmPasswordController,
            onChanged: onConfirmPasswordChanged,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please confirm your new password';
              }
              if (val != newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
