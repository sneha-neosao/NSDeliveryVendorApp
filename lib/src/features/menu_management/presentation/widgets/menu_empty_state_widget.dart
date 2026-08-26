import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../widgets/app_button_widget.dart';

class MenuEmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRefresh;

  const MenuEmptyStateWidget({
    super.key,
    this.title = 'No Menu Items Found',
    this.description =
        'You have not added any menu items to your restaurant yet. Once added, your dishes will appear here.',
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: AppColor.orangeTint,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primary.withValues(alpha: 0.2),
                  width: 2.r,
                ),
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 38.r,
                color: AppColor.primary,
              ),
            ),
            18.hS,
            // Title
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
            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              softWrap: true,
              style: AppFont.style(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.slateGrey,
                height: 1.4,
              ),
            ),
            if (onRefresh != null) ...[
              22.hS,
              AppButtonWidget(
                text: 'Refresh Menu',
                width: 160.w,
                height: 44.h,
                onPressed: onRefresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
