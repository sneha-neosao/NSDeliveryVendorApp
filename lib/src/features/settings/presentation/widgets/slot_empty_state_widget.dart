import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class SlotEmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRefresh;

  const SlotEmptyStateWidget({
    super.key,
    this.title = 'No Time Slots Found',
    this.description = 'There are no active time slots configured for your store.',
    this.icon = Icons.access_time_rounded,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.orangeTint2,
              ),
              child: Icon(
                icon,
                color: AppColor.primary,
                size: 44.r,
              ),
            ),
            18.hS,
            Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: AppFont.style(
                color: AppColor.charcoal,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            8.hS,
            Text(
              description,
              textAlign: TextAlign.center,
              softWrap: true,
              style: AppFont.style(
                color: AppColor.slateGrey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (onRefresh != null) ...[
              20.hS,
              GestureDetector(
                onTap: onRefresh,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        color: AppColor.pureWhite,
                        size: 16.r,
                      ),
                      6.wS,
                      Text(
                        'Refresh',
                        style: AppFont.style(
                          color: AppColor.pureWhite,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
