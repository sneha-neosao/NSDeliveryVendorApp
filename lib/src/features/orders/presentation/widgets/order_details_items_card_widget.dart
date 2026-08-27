import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/order_details_model/order_details_response.dart';

class OrderDetailsItemsCardWidget extends StatelessWidget {
  final List<OrderItemDetail> items;
  final int totalItems;

  const OrderDetailsItemsCardWidget({
    super.key,
    required this.items,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.8),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_menu_rounded,
                    size: 18.r,
                    color: AppColor.primary,
                  ),
                  8.wS,
                  Text(
                    'Order Items',
                    style: AppFont.style(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.charcoal,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColor.orangeTint2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '$totalItems ${totalItems == 1 ? "Item" : "Items"}',
                  style: AppFont.style(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryDark,
                  ),
                ),
              ),
            ],
          ),

          12.hS,

          Container(
            height: 1.h,
            color: AppColor.border.withValues(alpha: 0.5),
          ),

          12.hS,

          // ── Items List ────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length,
            separatorBuilder: (_, __) => Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Container(
                height: 1.h,
                color: AppColor.border.withValues(alpha: 0.3),
              ),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              final hasImage =
                  item.images != null && item.images!.isNotEmpty;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Item Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: 50.r,
                      height: 50.r,
                      color: AppColor.whiteShade,
                      child: hasImage
                          ? Image.network(
                              item.images!.first,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imagePlaceholder(),
                            )
                          : _imagePlaceholder(),
                    ),
                  ),
                  12.wS,

                  // Item Name & Variant
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.vendorItemName ?? '—',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppFont.style(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.charcoal,
                          ),
                        ),
                        if (item.variantName != null &&
                            item.variantName!.isNotEmpty) ...[
                          3.hS,
                          Text(
                            'Variant: ${item.variantName!}',
                            softWrap: true,
                            style: AppFont.style(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.slateGrey,
                            ),
                          ),
                        ],
                        4.hS,
                        Text(
                          '₹${(item.price ?? 0).toStringAsFixed(0)} × ${item.quantity ?? 1}',
                          style: AppFont.style(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.slateGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.wS,

                  // Total Price
                  Text(
                    '₹${(item.totalPrice ?? 0).toStringAsFixed(0)}',
                    softWrap: true,
                    style: AppFont.style(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Icon(
        Icons.fastfood_rounded,
        size: 22.r,
        color: AppColor.primary.withValues(alpha: 0.6),
      ),
    );
  }
}
