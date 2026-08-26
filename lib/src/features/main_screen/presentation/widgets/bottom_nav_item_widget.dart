import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class BottomNavItemWidget extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavItemWidget({
    super.key,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: isSelected
              ? Column(
                  key: ValueKey('active_$label'),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      activeIcon,
                      color: AppColor.primary,
                      size: 22.r,
                    ),
                    2.hS,
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColor.primary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                )
              : Icon(
                  key: ValueKey('inactive_$label'),
                  inactiveIcon,
                  color: AppColor.slateGrey,
                  size: 24.r,
                ),
        ),
      ),
    );
  }
}
