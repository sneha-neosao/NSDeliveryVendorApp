import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/orders_list_model/orders_list_response.dart';

/// Card widget representing a single ongoing order from the /orders/list API.
class OngoingOrderCardWidget extends StatelessWidget {
  final OrdersListItem order;
  final VoidCallback? onTap;
  final VoidCallback? onPrimaryActionTap;

  const OngoingOrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
    this.onPrimaryActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = order.orderStatus ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row: Receipt Icon + Order ID + Status Chip ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.orangeTint2,
                          ),
                          child: Icon(
                            Icons.receipt_rounded,
                            size: 16.r,
                            color: AppColor.primary,
                          ),
                        ),
                        8.wS,
                        Text(
                          'ORD_${order.id ?? ''}',
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: AppColor.charcoal,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    _buildStatusChip(context, status),
                  ],
                ),
                10.hS,

                // ── Divider ───────────────────────────────────────────
                Container(
                  height: 1.h,
                  color: AppColor.border.withValues(alpha: 0.5),
                ),
                10.hS,

                // ── Customer & Price Info ─────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer name
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 14.r,
                                color: AppColor.textSecondary,
                              ),
                              4.wS,
                              Flexible(
                                child: Text(
                                  order.customerName ?? '',
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColor.textPrimary,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          6.hS,
                          // Payment mode + Total items
                          Row(
                            children: [
                              Icon(
                                Icons.payment_rounded,
                                size: 13.r,
                                color: AppColor.textSecondary,
                              ),
                              4.wS,
                              Text(
                                order.paymentMode ?? '',
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColor.textSecondary,
                                      fontSize: 12.sp,
                                    ),
                              ),
                              12.wS,
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 13.r,
                                color: AppColor.textSecondary,
                              ),
                              4.wS,
                              Text(
                                '${order.totalItems ?? 0} ${(order.totalItems ?? 0) == 1 ? "Item" : "Items"}',
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColor.textSecondary,
                                      fontSize: 12.sp,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    12.wS,

                    // Grand Total
                    Text(
                      '₹${(order.grandTotal ?? 0).toStringAsFixed(0)}',
                      softWrap: true,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColor.primary,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ],
                ),

                // ── Footer Action ─────────────────────────────────────
                12.hS,
                Row(
                  children: [
                    // Payment status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: _paymentStatusColor(order.paymentStatus)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        order.paymentStatus ?? '',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color:
                                      _paymentStatusColor(order.paymentStatus),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    const Spacer(),
                    _buildActionButton(context, status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String status) {
    String label;
    switch (status.toUpperCase()) {
      case 'PENDING':
        label = 'Accept Order';
        break;
      case 'PREPARING':
        label = 'Mark Ready';
        break;
      case 'READY':
        label = 'Dispatch';
        break;
      default:
        label = 'View Details';
    }

    return GestureDetector(
      onTap: onPrimaryActionTap ?? onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.primary, AppColor.darkOrange],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColor.pureWhite,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            4.wS,
            Icon(
              Icons.arrow_forward_rounded,
              size: 13.r,
              color: AppColor.pureWhite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color bg;
    Color fg;
    String label;

    switch (status.toUpperCase()) {
      case 'PENDING':
        bg = AppColor.orangeTint;
        fg = AppColor.primaryDark;
        label = 'New Order';
        break;
      case 'PREPARING':
        bg = AppColor.orangeTint2;
        fg = AppColor.primary;
        label = 'Preparing';
        break;
      case 'READY':
        bg = AppColor.green.withValues(alpha: 0.12);
        fg = AppColor.green;
        label = 'Ready';
        break;
      case 'DELIVERED':
        bg = AppColor.green.withValues(alpha: 0.12);
        fg = AppColor.green;
        label = 'Delivered';
        break;
      case 'CANCELLED':
        bg = AppColor.bright_red.withValues(alpha: 0.12);
        fg = AppColor.bright_red;
        label = 'Cancelled';
        break;
      default:
        bg = AppColor.orangeTint;
        fg = AppColor.primaryDark;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: fg,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Color _paymentStatusColor(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'PAID':
        return AppColor.green;
      case 'PENDING':
        return AppColor.primary;
      case 'FAILED':
        return AppColor.bright_red;
      default:
        return AppColor.slateGrey;
    }
  }
}
