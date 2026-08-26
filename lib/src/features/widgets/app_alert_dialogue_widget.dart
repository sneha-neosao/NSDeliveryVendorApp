import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/extensions/integer_sizedbox_extension.dart';
import '../../core/theme/app_color.dart';
import '../../core/theme/app_font.dart';

class AppAlertDialogWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color confirmBtnColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;
  final bool showCloseIcon;

  const AppAlertDialogWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.confirmText,
    this.cancelText = 'Cancel',
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.confirmBtnColor,
    required this.onConfirm,
    this.onCancel,
    this.isLoading = false,
    this.showCloseIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading,
      child: Dialog(
        backgroundColor: AppColor.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Top Icon Container ─────────────────────────
                  Container(
                    width: 64.r,
                    height: 64.r,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: iconColor.withValues(alpha: 0.25),
                        width: 1.5.r,
                      ),
                    ),
                    child: Icon(icon, color: iconColor, size: 30.r),
                  ),

                  16.hS,

                  // ── Title ──────────────────────────────────────
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: AppFont.style(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColor.charcoal,
                    ),
                  ),

                  8.hS,

                  // ── Subtitle ───────────────────────────────────
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: AppFont.style(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.slateGrey,
                      height: 1.4,
                    ),
                  ),

                  24.hS,

                  // ── Action Buttons (Equal Height & Width) ──────
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: OutlinedButton(
                            onPressed: isLoading
                                ? null
                                : (onCancel ?? () => Navigator.pop(context)),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColor.whiteShade,
                              side: BorderSide(
                                color: AppColor.border.withValues(alpha: 0.8),
                                width: 1.r,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              cancelText,
                              style: AppFont.style(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.charcoal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      12.wS,
                      // Confirm Button (Matching Height & Width)
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : onConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: confirmBtnColor,
                              foregroundColor: AppColor.pureWhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20.r,
                                    height: 20.r,
                                    child: const CircularProgressIndicator(
                                      color: AppColor.pureWhite,
                                      strokeWidth: 2.2,
                                    ),
                                  )
                                : Text(
                                    confirmText,
                                    style: AppFont.style(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColor.pureWhite,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Optional Close Icon ──────────────────────────────
            if (showCloseIcon && !isLoading)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.close,
                      size: 20.r,
                      color: AppColor.slateGrey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
