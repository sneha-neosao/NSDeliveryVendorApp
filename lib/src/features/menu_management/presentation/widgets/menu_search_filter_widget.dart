import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class MenuSearchFilterWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedStatus; // 'Active', 'Inactive', or null
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<String?> onStatusChanged;

  const MenuSearchFilterWidget({
    super.key,
    required this.searchController,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search Field (Corners rounded 25.r like AppButtonWidget) ──
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(
                color: AppColor.border.withValues(alpha: 0.8),
                width: 1.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: AppFont.style(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.charcoal,
                ),
                decoration: InputDecoration(
                  hintText: 'Search menu items...',
                  hintStyle: AppFont.style(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.slateGrey,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColor.primary,
                    size: 22.r,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18.r,
                            color: AppColor.slateGrey,
                          ),
                          onPressed: onClearSearch,
                        )
                      : null,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 13.h,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),

          12.hS,

          // ── 2 Option Chips (Active & Inactive - No Counts) ──
          Row(
            children: [
              _buildFilterChip(
                label: 'Active',
                isSelected: selectedStatus == 'Active',
                color: AppColor.green,
                onTap: () {
                  onStatusChanged(selectedStatus == 'Active' ? null : 'Active');
                },
              ),
              10.wS,
              _buildFilterChip(
                label: 'Inactive',
                isSelected: selectedStatus == 'Inactive',
                color: AppColor.bright_red,
                onTap: () {
                  onStatusChanged(
                      selectedStatus == 'Inactive' ? null : 'Inactive');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 7.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : AppColor.pureWhite,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? color
                : AppColor.border.withValues(alpha: 0.8),
            width: isSelected ? 1.5.r : 1.r,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Dot
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            8.wS,
            // Label
            Text(
              label,
              style: AppFont.style(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? color : AppColor.charcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
