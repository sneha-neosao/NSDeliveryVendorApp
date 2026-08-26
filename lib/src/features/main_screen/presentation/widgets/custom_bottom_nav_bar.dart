import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_color.dart';
import 'bottom_nav_item_widget.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: 64.h,
        margin: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          bottom: 14.h,
          top: 6.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(36.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final itemWidth = totalWidth / 3;
            final capsuleWidth = itemWidth - 10.w;
            final capsuleHeight = 50.h;
            final leftOffset =
                selectedIndex * itemWidth + (itemWidth - capsuleWidth) / 2;
            final topOffset = (constraints.maxHeight - capsuleHeight) / 2;

            return Stack(
              children: [
                // Smooth Gliding Active Indicator Pill
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  left: leftOffset,
                  top: topOffset,
                  width: capsuleWidth,
                  height: capsuleHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColor.orangeTint2,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
                // Tab Items
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: BottomNavItemWidget(
                          activeIcon: Icons.grid_view_rounded,
                          inactiveIcon: Icons.grid_view_outlined,
                          label: 'Dashboard',
                          isSelected: selectedIndex == 0,
                          onTap: () => onTabSelected(0),
                        ),
                      ),
                      Expanded(
                        child: BottomNavItemWidget(
                          activeIcon: Icons.shopping_bag_rounded,
                          inactiveIcon: Icons.shopping_bag_outlined,
                          label: 'Orders',
                          isSelected: selectedIndex == 1,
                          onTap: () => onTabSelected(1),
                        ),
                      ),
                      Expanded(
                        child: BottomNavItemWidget(
                          activeIcon: Icons.restaurant_menu_rounded,
                          inactiveIcon: Icons.restaurant_menu_outlined,
                          label: 'Menu',
                          isSelected: selectedIndex == 2,
                          onTap: () => onTabSelected(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
