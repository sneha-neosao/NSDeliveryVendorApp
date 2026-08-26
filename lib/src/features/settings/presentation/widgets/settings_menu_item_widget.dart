import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class SettingsMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool showTrailing;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const SettingsMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.showTrailing = true,
    this.iconColor,
    this.iconBackgroundColor,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColor.primary;
    final effectiveIconBgColor =
        iconBackgroundColor ?? AppColor.orangeTint2.withValues(alpha: 0.7);
    final effectiveTitleColor = titleColor ?? AppColor.charcoal;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.35),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          splashColor: AppColor.orangeTint2.withValues(alpha: 0.4),
          highlightColor: AppColor.orangeTint2.withValues(alpha: 0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Leading Icon Container
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(
                    color: effectiveIconBgColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveIconColor,
                    size: 24.r,
                  ),
                ),
                14.wS,
                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: effectiveTitleColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      3.hS,
                      Text(
                        subtitle,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColor.slateGrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
                if (showTrailing) ...[
                  10.wS,
                  trailing ??
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColor.slateGrey.withValues(alpha: 0.7),
                        size: 22.r,
                      ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
