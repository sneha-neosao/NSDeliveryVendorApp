import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/dashboard_model/performance_metrics_response.dart';

class TopProductsWidget extends StatelessWidget {
  final List<TopProduct> topProducts;
  final bool isLoading;

  const TopProductsWidget({
    super.key,
    this.topProducts = const [],
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.5),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColor.orangeTint2,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColor.primary,
                  size: 20.r,
                ),
              ),
              10.wS,
              Expanded(
                child: Text(
                  'Top Selling Dishes',
                  softWrap: true,
                  style: AppFont.style(
                    color: AppColor.charcoal,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isLoading)
                Shimmer.fromColors(
                  baseColor: AppColor.border.withValues(alpha: 0.35),
                  highlightColor: AppColor.pureWhite,
                  child: Container(
                    width: 52.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppColor.pureWhite,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                )
              else if (topProducts.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColor.orangeTint2,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${topProducts.length} Items',
                    style: AppFont.style(
                      color: AppColor.primary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          16.hS,

          // ── Content ─────────────────────────────────────────────
          if (isLoading)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 3,
              separatorBuilder: (context, index) => 12.hS,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: AppColor.border.withValues(alpha: 0.35),
                  highlightColor: AppColor.pureWhite,
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColor.whiteShade,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColor.border.withValues(alpha: 0.45),
                        width: 1.r,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Rank Badge placeholder
                        Container(
                          width: 26.r,
                          height: 26.r,
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        10.wS,

                        // Image placeholder
                        Container(
                          width: 48.r,
                          height: 48.r,
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        12.wS,

                        // Text placeholder lines
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 130.w,
                                height: 14.h,
                                decoration: BoxDecoration(
                                  color: AppColor.pureWhite,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              6.hS,
                              Container(
                                width: 60.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: AppColor.pureWhite,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          else if (topProducts.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.fastfood_outlined,
                      color: AppColor.slateGrey.withValues(alpha: 0.5),
                      size: 36.r,
                    ),
                    8.hS,
                    Text(
                      'No sales data available yet',
                      style: AppFont.style(
                        color: AppColor.slateGrey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: topProducts.length,
              separatorBuilder: (context, index) => 12.hS,
              itemBuilder: (context, index) {
                final product = topProducts[index];
                return _buildProductItem(context, product, index + 1);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
      BuildContext context, TopProduct product, int rank) {
    final hasImage =
        product.itemImage != null && product.itemImage!.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColor.whiteShade,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.45),
          width: 1.r,
        ),
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 26.r,
            height: 26.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: rank == 1
                  ? AppColor.primary
                  : rank == 2
                      ? AppColor.darkOrange
                      : AppColor.slateGrey.withValues(alpha: 0.25),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: AppFont.style(
                  color: rank <= 2 ? AppColor.pureWhite : AppColor.charcoal,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          10.wS,

          // Product Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 48.r,
              height: 48.r,
              color: AppColor.whiteDark,
              child: hasImage
                  ? Image.network(
                      product.itemImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.restaurant_rounded,
                        color: AppColor.slateGrey.withValues(alpha: 0.5),
                        size: 22.r,
                      ),
                    )
                  : Icon(
                      Icons.restaurant_rounded,
                      color: AppColor.slateGrey.withValues(alpha: 0.5),
                      size: 22.r,
                    ),
            ),
          ),
          12.wS,

          // Product Name & Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.itemName?.isNotEmpty == true
                      ? product.itemName!
                      : 'Item',
                  softWrap: true,
                  style: AppFont.style(
                    color: AppColor.charcoal,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                4.hS,
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColor.primary,
                      size: 13.r,
                    ),
                    4.wS,
                    Text(
                      '${product.unitsSold ?? 0} sold',
                      style: AppFont.style(
                        color: AppColor.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
