import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OrdersTabSelectorWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final int ongoingCount;
  final int historyCount;

  const OrdersTabSelectorWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.ongoingCount = 0,
    this.historyCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.7),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          final tabHeight = constraints.maxHeight;

          return Stack(
            children: [
              // Gliding Animated Gradient Capsule
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                left: selectedIndex * tabWidth,
                top: 0,
                width: tabWidth,
                height: tabHeight,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.primary,
                        AppColor.darkOrange,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              // Tab Items Row
              Positioned.fill(
                child: Row(
                  children: [
                    // Ongoing Orders Tab
                    Expanded(
                      child: _buildTabItem(
                        context: context,
                        index: 0,
                        title: 'Ongoing Orders',
                        icon: Icons.bolt_rounded,
                        count: ongoingCount,
                        showLiveDot: true,
                      ),
                    ),
                    // Order History Tab
                    Expanded(
                      child: _buildTabItem(
                        context: context,
                        index: 1,
                        title: 'Order History',
                        icon: Icons.history_rounded,
                        count: historyCount,
                        showLiveDot: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
    required int count,
    required bool showLiveDot,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabChanged(index),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: isSelected ? AppColor.pureWhite : AppColor.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13.sp,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tab Icon
              Icon(
                icon,
                size: 17.r,
                color: isSelected ? AppColor.pureWhite : AppColor.textSecondary,
              ),
              6.wS,
              // Tab Title
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              // Live Dot or Badge Count
              if (showLiveDot && isSelected) ...[
                6.wS,
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.pureWhite,
                  ),
                ),
              ] else if (count > 0 && !isSelected) ...[
                6.wS,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.orangeTint,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: AppColor.primaryDark,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
