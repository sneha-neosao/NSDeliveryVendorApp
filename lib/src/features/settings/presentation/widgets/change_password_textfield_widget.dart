import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class ChangePasswordTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final bool isSecure;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const ChangePasswordTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.isSecure = true,
    this.onChanged,
    this.validator,
  });

  @override
  State<ChangePasswordTextField> createState() =>
      _ChangePasswordTextFieldState();
}

class _ChangePasswordTextFieldState extends State<ChangePasswordTextField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label with Asterisk
        Row(
          children: [
            Text(
              widget.label,
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

        // Input Field
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isSecure ? _isObscured : false,
          onChanged: widget.onChanged,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppFont.style(
            color: AppColor.charcoal,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppFont.style(
              color: AppColor.slateGrey.withValues(alpha: 0.6),
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              color: AppColor.primary,
              size: 20.r,
            ),
            suffixIcon: widget.isSecure
                ? IconButton(
                    onPressed: _toggleVisibility,
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColor.slateGrey.withValues(alpha: 0.8),
                      size: 20.r,
                    ),
                  )
                : null,
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
    );
  }
}
