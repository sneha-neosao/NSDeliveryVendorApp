import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final String greeting;
  final String vendorName;
  final VoidCallback? onSettingsTap;

  const DashboardHeaderWidget({
    super.key,
    this.greeting = 'Good Morning,',
    this.vendorName = 'Aashu Kale',
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Vendor Avatar with border
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.pureWhite,
            border: Border.all(
              color: AppColor.pureWhite,
              width: 2.r,
            ),
          ),
          child: ClipOval(
            child: Container(
              color: AppColor.orangeTint2,
              child: Icon(
                Icons.storefront_rounded,
                color: AppColor.primary,
                size: 26.r,
              ),
            ),
          ),
        ),
        12.wS,
        // Greeting & Vendor Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                greeting,
                softWrap: true,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColor.pureWhite.withValues(alpha: 0.9),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              2.hS,
              Text(
                vendorName,
                softWrap: true,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColor.pureWhite,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        12.wS,
        // Settings Icon Button
        GestureDetector(
          onTap: onSettingsTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.pureWhite.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: AppColor.pureWhite,
              size: 22.r,
            ),
          ),
        ),
      ],
    );
  }
}
