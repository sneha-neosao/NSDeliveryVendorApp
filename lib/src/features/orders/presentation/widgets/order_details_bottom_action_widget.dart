import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class OrderDetailsBottomActionWidget extends StatelessWidget {
  final String? orderStatus;
  final VoidCallback? onAcceptTap;
  final VoidCallback? onReadyTap;
  final bool isLoading;

  const OrderDetailsBottomActionWidget({
    super.key,
    required this.orderStatus,
    this.onAcceptTap,
    this.onReadyTap,
    this.isLoading = false,
  });

  static bool shouldShow(String? status) {
    final s = (status ?? '').toUpperCase();
    return s == 'PENDING' ||
        s == 'NEW' ||
        s == 'PLACED' ||
        s == 'PREPARING' ||
        s == 'COOKING' ||
        s == 'DEL_ACCEPTED';
  }

  @override
  Widget build(BuildContext context) {
    final status = (orderStatus ?? '').toUpperCase();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    if (!shouldShow(orderStatus)) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 12.h,
        bottom: bottomPadding > 0 ? bottomPadding + 8.h : 14.h,
      ),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.8),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: _buildButton(context, status),
    );
  }

  Widget _buildButton(BuildContext context, String status) {
    if (status == 'PENDING' || status == 'NEW' || status == 'PLACED') {
      // 1. PENDING -> Active ACCEPT & PREPARE button
      return GestureDetector(
        onTap: isLoading ? null : onAcceptTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.primary, AppColor.darkOrange],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColor.pureWhite,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_rounded,
                      size: 18.r,
                      color: AppColor.pureWhite,
                    ),
                    8.wS,
                    Text(
                      'ACCEPT & PREPARE',
                      style: AppFont.style(
                        color: AppColor.pureWhite,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      );
    } else if (status == 'PREPARING' || status == 'COOKING') {
      // 2. PREPARING -> Inactive READY FOR PICKUP button
      return Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColor.gray.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColor.gray.withValues(alpha: 0.35),
            width: 1.r,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 18.r,
              color: AppColor.slateGrey,
            ),
            8.wS,
            Text(
              'READY FOR PICKUP',
              style: AppFont.style(
                color: AppColor.slateGrey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    } else if (status == 'DEL_ACCEPTED') {
      // 3. DEL_ACCEPTED -> Active READY FOR PICKUP button
      return GestureDetector(
        onTap: isLoading ? null : onReadyTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.primary, AppColor.darkOrange],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColor.pureWhite,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 18.r,
                      color: AppColor.pureWhite,
                    ),
                    8.wS,
                    Text(
                      'READY FOR PICKUP',
                      style: AppFont.style(
                        color: AppColor.pureWhite,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
