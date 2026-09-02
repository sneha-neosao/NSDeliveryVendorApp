import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class CreateOfferHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBackTap;

  const CreateOfferHeaderWidget({
    super.key,
    this.title = 'Add Promotional Offer',
    this.subtitle = 'Create a new discount offer for customers',
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 8.h,
        left: 18.w,
        right: 18.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primary,
            AppColor.darkOrange,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkOrange.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
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
                color: AppColor.pureWhite.withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColor.pureWhite,
                size: 18.r,
              ),
            ),
          ),
          12.wS,

          // Center Title + Subtitle
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: AppFont.style(
                    color: AppColor.pureWhite,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  2.hS,
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: AppFont.style(
                      color: AppColor.pureWhite.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          12.wS,

          // Right Spacer to balance the back button
          SizedBox(width: 38.r),
        ],
      ),
    );
  }
}
