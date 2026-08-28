import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/items_model/items_list_response.dart';

class MenuItemCardWidget extends StatelessWidget {
  final RestaurantItem item;
  final bool isLoading;
  final VoidCallback? onTap;

  const MenuItemCardWidget({
    super.key,
    required this.item,
    this.isLoading = false,
    this.onTap,
  });

  bool get _isNonVeg {
    final cuisine = item.cuisineType?.toLowerCase() ?? '';
    return cuisine.contains('non') ||
        cuisine.contains('egg') ||
        cuisine.contains('meat');
  }

  String? get _primaryImageUrl {
    if (item.images == null || item.images!.isEmpty) return null;
    final primary = item.images!.firstWhere(
      (img) => img.isPrimary == true && (img.itemImage?.isNotEmpty ?? false),
      orElse: () => item.images!.first,
    );
    return primary.itemImage;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _primaryImageUrl;
    // item_status is the serviceability flag
    final isItemServiceable = item.itemStatus == true;
    final borderColor =
        isItemServiceable ? AppColor.green : AppColor.bright_red;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: borderColor,
                width: 1.5.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: isItemServiceable
                      ? AppColor.green.withValues(alpha: 0.08)
                      : AppColor.bright_red.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left Column: Details ─────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Veg/Non-Veg + Category Tag
                      Row(
                        children: [
                          _buildDietBadge(),
                          if (item.menuCategory?.menuCategoryName != null &&
                              item.menuCategory!.menuCategoryName!.isNotEmpty) ...[
                            8.wS,
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.orangeTint2,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  item.menuCategory!.menuCategoryName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: AppFont.style(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.primaryDark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      8.hS,

                      // Item Name
                      Text(
                        item.itemName ?? 'Unnamed Item',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFont.style(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.charcoal,
                        ),
                      ),

                      6.hS,

                      // Price + Rating + Prep Time
                      Row(
                        children: [
                          // Price
                          Text(
                            '₹${item.salePrice != null ? (item.salePrice! % 1 == 0 ? item.salePrice!.toInt() : item.salePrice!.toStringAsFixed(2)) : 0}',
                            style: AppFont.style(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColor.primary,
                            ),
                          ),
                          if (item.avgRating != null &&
                              item.avgRating! > 0) ...[
                            10.wS,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColor.green.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 13.r,
                                    color: AppColor.green,
                                  ),
                                  3.wS,
                                  Text(
                                    item.avgRating!.toStringAsFixed(1),
                                    style: AppFont.style(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (item.preparationTime != null &&
                              item.preparationTime! > 0) ...[
                            10.wS,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 13.r,
                                  color: AppColor.slateGrey,
                                ),
                                3.wS,
                                Text(
                                  '${item.preparationTime}m',
                                  style: AppFont.style(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.slateGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),

                      if (item.description != null &&
                          item.description!.isNotEmpty) ...[
                        8.hS,
                        Text(
                          item.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: AppFont.style(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.slateGrey,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                14.wS,

                // ── Right Column: Image & Serviceability Status Badge ──
                Column(
                  children: [
                    // Image Box
                    Container(
                      width: 86.r,
                      height: 86.r,
                      decoration: BoxDecoration(
                        color: AppColor.orangeTint2,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColor.border.withValues(alpha: 0.5),
                          width: 1.r,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13.r),
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImageFallback(),
                              )
                            : _buildImageFallback(),
                      ),
                    ),
                    8.hS,
                    // Serviceability Status Badge (Available / Unavailable)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isItemServiceable
                            ? AppColor.green.withValues(alpha: 0.12)
                            : AppColor.bright_red.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: isItemServiceable
                                  ? AppColor.green
                                  : AppColor.bright_red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          4.wS,
                          Text(
                            isItemServiceable ? 'Available' : 'Unavailable',
                            style: AppFont.style(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: isItemServiceable
                                  ? AppColor.green
                                  : AppColor.bright_red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Blurry Overlay with Loader when Toggling Serviceability Status ──
          if (isLoading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                  child: Container(
                    color: AppColor.pureWhite.withValues(alpha: 0.6),
                    child: Center(
                      child: SizedBox(
                        width: 28.r,
                        height: 28.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDietBadge() {
    final color = _isNonVeg ? AppColor.bright_red : AppColor.green;

    return Container(
      width: 15.r,
      height: 15.r,
      padding: EdgeInsets.all(2.5.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        border: Border.all(color: color, width: 1.5.r),
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildImageFallback() {
    return Center(
      child: Icon(
        Icons.fastfood_rounded,
        size: 32.r,
        color: AppColor.primary.withValues(alpha: 0.6),
      ),
    );
  }
}
