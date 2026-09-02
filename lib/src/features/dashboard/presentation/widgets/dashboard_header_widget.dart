import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final String greeting;
  final String vendorName;
  final String? userImage;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;

  const DashboardHeaderWidget({
    super.key,
    this.greeting = 'Hello,',
    this.vendorName = 'Vendor',
    this.userImage,
    this.onProfileTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final handleTap = onProfileTap ?? onSettingsTap;
    final hasUserImage = userImage != null &&
        userImage!.trim().isNotEmpty &&
        userImage!.trim().toLowerCase() != 'null' &&
        userImage!.trim().toLowerCase() != 'string';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 10.h,
        left: 18.w,
        right: 18.w,
        bottom: 18.h,
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
          // Vendor Avatar with white border
          GestureDetector(
            onTap: handleTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.pureWhite,
                border: Border.all(
                  color: AppColor.pureWhite,
                  width: 2.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  color: AppColor.orangeTint2,
                  child: hasUserImage
                      ? Image.network(
                          userImage!.trim(),
                          width: 48.r,
                          height: 48.r,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.storefront_rounded,
                              color: AppColor.primary,
                              size: 26.r,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColor.primary,
                            size: 26.r,
                          ),
                        ),
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
                  style: AppFont.style(
                    color: AppColor.pureWhite.withValues(alpha: 0.9),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                2.hS,
                Text(
                  vendorName,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppFont.style(
                    color: AppColor.pureWhite,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          12.wS,

          // Profile Icon Button
          GestureDetector(
            onTap: handleTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.pureWhite.withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppColor.pureWhite,
                size: 24.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
