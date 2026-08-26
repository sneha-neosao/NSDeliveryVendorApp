import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

enum OrderStatus {
  newOrder,
  preparing,
  ready,
  delivered,
  cancelled,
}

class OrderCardItemData {
  final String orderId;
  final String customerName;
  final String itemsSummary;
  final int itemCount;
  final String totalAmount;
  final String time;
  final OrderStatus status;

  const OrderCardItemData({
    required this.orderId,
    required this.customerName,
    required this.itemsSummary,
    required this.itemCount,
    required this.totalAmount,
    required this.time,
    required this.status,
  });
}

class OrderCardWidget extends StatelessWidget {
  final OrderCardItemData order;
  final VoidCallback? onTap;
  final VoidCallback? onPrimaryActionTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
    this.onPrimaryActionTap,
  });

  @override
  Widget build(BuildContext context) {
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
                // Top Row: Order ID & Status Chip
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
                          order.orderId,
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
                    _buildStatusChip(context, order.status),
                  ],
                ),
                10.hS,
                // Divider line
                Container(
                  height: 1.h,
                  color: AppColor.border.withValues(alpha: 0.5),
                ),
                10.hS,
                // Customer & Items info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 14.r,
                                color: AppColor.textSecondary,
                              ),
                              4.wS,
                              Expanded(
                                child: Text(
                                  order.customerName,
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
                          4.hS,
                          Text(
                            order.itemsSummary,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColor.textSecondary,
                                  fontSize: 12.sp,
                                  height: 1.3,
                                ),
                          ),
                        ],
                      ),
                    ),
                    12.wS,
                    // Price & Time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          order.totalAmount,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: AppColor.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        2.hS,
                        Text(
                          order.time,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColor.slateGrey,
                                fontSize: 11.sp,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Footer Action if ongoing
                if (_hasPrimaryAction(order.status)) ...[
                  12.hS,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteShade,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${order.itemCount} ${order.itemCount == 1 ? "Item" : "Items"}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColor.textSecondary,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      const Spacer(),
                      _buildActionButton(context, order.status),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasPrimaryAction(OrderStatus status) {
    return status == OrderStatus.newOrder ||
        status == OrderStatus.preparing ||
        status == OrderStatus.ready;
  }

  Widget _buildActionButton(BuildContext context, OrderStatus status) {
    String actionTitle = 'View Details';
    if (status == OrderStatus.newOrder) {
      actionTitle = 'Accept Order';
    } else if (status == OrderStatus.preparing) {
      actionTitle = 'Mark Ready';
    } else if (status == OrderStatus.ready) {
      actionTitle = 'Dispatch';
    }

    return GestureDetector(
      onTap: onPrimaryActionTap ?? onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 6.h,
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
              actionTitle,
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

  Widget _buildStatusChip(BuildContext context, OrderStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case OrderStatus.newOrder:
        bg = AppColor.orangeTint;
        fg = AppColor.primaryDark;
        label = 'New Order';
        break;
      case OrderStatus.preparing:
        bg = AppColor.orangeTint2;
        fg = AppColor.primary;
        label = 'Preparing';
        break;
      case OrderStatus.ready:
        bg = AppColor.green.withValues(alpha: 0.12);
        fg = AppColor.green;
        label = 'Ready';
        break;
      case OrderStatus.delivered:
        bg = AppColor.green.withValues(alpha: 0.12);
        fg = AppColor.green;
        label = 'Delivered';
        break;
      case OrderStatus.cancelled:
        bg = AppColor.bright_red.withValues(alpha: 0.12);
        fg = AppColor.bright_red;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9.w,
        vertical: 4.h,
      ),
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
}
