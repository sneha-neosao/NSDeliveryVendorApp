import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class OffersEmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRefresh;

  const OffersEmptyStateWidget({
    super.key,
    this.title = 'No Active Offers',
    this.description =
        'Create special discounts, coupon codes, and bundle promotions to attract more customers to your store.',
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.orangeTint2,
                border: Border.all(
                  color: AppColor.primary.withValues(alpha: 0.2),
                  width: 2.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.local_offer_outlined,
                  size: 40.r,
                  color: AppColor.primary,
                ),
              ),
            ),
            18.hS,
            Text(
              title,
              softWrap: true,
              textAlign: TextAlign.center,
              style: AppFont.style(
                color: AppColor.charcoal,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            8.hS,
            Text(
              description,
              softWrap: true,
              textAlign: TextAlign.center,
              style: AppFont.style(
                color: AppColor.slateGrey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            if (onRefresh != null) ...[
              20.hS,
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 18.r,
                  color: AppColor.pureWhite,
                ),
                label: Text(
                  'Refresh',
                  style: AppFont.style(
                    color: AppColor.pureWhite,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
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
