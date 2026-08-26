import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OrderEmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRefresh;

  const OrderEmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.receipt_long_outlined,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 48.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorative Icon Container
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.orangeTint2,
                border: Border.all(
                  color: AppColor.border,
                  width: 1.5.r,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 42.r,
                  color: AppColor.primary,
                ),
              ),
            ),
            20.hS,
            // Empty State Title
            Text(
              title,
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColor.charcoal,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            8.hS,
            // Empty State Description
            Text(
              description,
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.textSecondary,
                    fontSize: 13.sp,
                    height: 1.4,
                  ),
            ),
            if (onRefresh != null) ...[
              20.hS,
              GestureDetector(
                onTap: onRefresh,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.orangeTint,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 16.r,
                        color: AppColor.primary,
                      ),
                      6.wS,
                      Text(
                        'Refresh',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColor.primaryDark,
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
