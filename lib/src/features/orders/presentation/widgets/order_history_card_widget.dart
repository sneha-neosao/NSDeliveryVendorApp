import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/order_history_model/order_history_response.dart';

class OrderHistoryCardWidget extends StatelessWidget {
  final OrderHistoryItem order;
  final VoidCallback? onTap;

  const OrderHistoryCardWidget({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final paymentColor = _paymentColor(order.paymentStatus);
    final formattedDate = _formatDate(order.createdAt);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
            // ── Row 1: Order ID + Order Status Badge ─────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORD_${order.id ?? '---'}',
                  style: AppFont.style(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.charcoal,
                  ),
                ),
                _buildStatusBadge(order.orderStatus),
              ],
            ),

            8.hS,

            // ── Row 2: Customer Name ──────────────────────────────
            Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 14.r, color: AppColor.slateGrey),
                5.wS,
                Flexible(
                  child: Text(
                    order.customerName ?? '—',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: AppFont.style(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.charcoal,
                    ),
                  ),
                ),
                8.wS,
                Icon(Icons.call_outlined,
                    size: 13.r, color: AppColor.slateGrey),
                4.wS,
                Flexible(
                  child: Text(
                    order.customerContact ?? '—',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: AppFont.style(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.slateGrey,
                    ),
                  ),
                ),
              ],
            ),

            10.hS,

            // ── Row 3: Grand Total + Items count ─────────────────
            Row(
              children: [
                Icon(Icons.currency_rupee_rounded,
                    size: 14.r, color: AppColor.primary),
                2.wS,
                Text(
                  order.grandTotal?.toStringAsFixed(0) ?? '0',
                  style: AppFont.style(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.primary,
                  ),
                ),
                14.wS,
                Icon(Icons.shopping_bag_outlined,
                    size: 14.r, color: AppColor.slateGrey),
                4.wS,
                Text(
                  '${order.totalItems ?? 0} item${(order.totalItems ?? 0) > 1 ? 's' : ''}',
                  style: AppFont.style(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.slateGrey,
                  ),
                ),
              ],
            ),

            8.hS,

            // ── Row 4: Payment Mode + Payment Status + Date ───────
            Row(
              children: [
                // Payment mode pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.orangeTint2,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    order.paymentMode ?? '—',
                    style: AppFont.style(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primaryDark,
                    ),
                  ),
                ),

                8.wS,

                // Payment status dot + label
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: paymentColor,
                  ),
                ),
                4.wS,
                Text(
                  order.paymentStatus ?? '—',
                  style: AppFont.style(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: paymentColor,
                  ),
                ),

                const Spacer(),

                // Date
                Icon(Icons.schedule_rounded,
                    size: 12.r, color: AppColor.slateGrey),
                4.wS,
                Text(
                  formattedDate,
                  style: AppFont.style(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.slateGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color bg;
    Color fg;
    String label;

    switch ((status ?? '').toUpperCase()) {
      case 'PENDING':
      case 'NEW':
      case 'PLACED':
        bg = AppColor.statusPendingBg;
        fg = AppColor.statusPending;
        label = 'New Order';
        break;
      case 'ACCEPTED':
      case 'CONFIRMED':
      case 'DEL_ACCEPTED':
        bg = AppColor.statusConfirmedBg;
        fg = AppColor.statusConfirmed;
        label = 'Accepted';
        break;
      case 'PREPARING':
      case 'COOKING':
        bg = AppColor.statusPreparingBg;
        fg = AppColor.statusPreparing;
        label = 'Preparing';
        break;
      case 'READY':
      case 'READY_FOR_PICKUP':
        bg = AppColor.statusReadyBg;
        fg = AppColor.statusReady;
        label = 'Ready';
        break;
      case 'OUT_FOR_DELIVERY':
      case 'ON_THE_WAY':
      case 'DISPATCHED':
        bg = AppColor.statusDispatchedBg;
        fg = AppColor.statusDispatched;
        label = 'Dispatched';
        break;
      case 'DELIVERED':
      case 'COMPLETED':
        bg = AppColor.statusDeliveredBg;
        fg = AppColor.statusDelivered;
        label = 'Delivered';
        break;
      case 'CANCELLED':
        bg = AppColor.statusCancelledBg;
        fg = AppColor.statusCancelled;
        label = 'Cancelled';
        break;
      case 'REJECTED':
        bg = AppColor.statusCancelledBg;
        fg = AppColor.statusCancelled;
        label = 'Rejected';
        break;
      default:
        bg = AppColor.whiteShade;
        fg = AppColor.slateGrey;
        label = (status != null && status.isNotEmpty)
            ? status[0].toUpperCase() + status.substring(1).toLowerCase()
            : '—';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: fg.withValues(alpha: 0.35), width: 1.r),
      ),
      child: Text(
        label,
        style: AppFont.style(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }

  Color _paymentColor(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'PAID':
        return AppColor.green;
      case 'PENDING':
        return AppColor.secondary;
      case 'FAILED':
        return AppColor.bright_red;
      default:
        return AppColor.slateGrey;
    }
  }

  String _formatStatus(String? status) {
    if (status == null || status.isEmpty) return '—';
    final s = status.toLowerCase();
    return s[0].toUpperCase() + s.substring(1);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final dt = DateTime.parse(dateStr);
      final day = dt.day.toString().padLeft(2, '0');
      final month = _monthShort(dt.month);
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day $month, $hour:$minute $period';
    } catch (_) {
      return dateStr;
    }
  }

  String _monthShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
