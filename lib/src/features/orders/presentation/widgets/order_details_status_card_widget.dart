import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/order_details_model/order_details_response.dart';

class OrderDetailsStatusCardWidget extends StatelessWidget {
  final OrderDetailsData order;

  const OrderDetailsStatusCardWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.orderStatus);
    final formattedCreated = _formatDate(order.createdAt);
    final formattedDelivery = _formatDate(order.deliveryDate);

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
          // ── Top Row: Order ID + Status Chip ────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.orangeTint2,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      size: 16.r,
                      color: AppColor.primary,
                    ),
                  ),
                  8.wS,
                  Text(
                    'ORD_${order.id ?? ''}',
                    softWrap: true,
                    style: AppFont.style(
                      color: AppColor.charcoal,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(order.orderStatus, statusColor),
            ],
          ),

          12.hS,

          // ── Divider ───────────────────────────────────────────
          Container(
            height: 1.h,
            color: AppColor.border.withValues(alpha: 0.5),
          ),

          12.hS,

          // ── Order Placement Time ──────────────────────────────
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.r,
                color: AppColor.slateGrey,
              ),
              6.wS,
              Text(
                'Placed on:',
                style: AppFont.style(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.slateGrey,
                ),
              ),
              6.wS,
              Expanded(
                child: Text(
                  formattedCreated,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: AppFont.style(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.charcoal,
                  ),
                ),
              ),
            ],
          ),

          if (formattedDelivery.isNotEmpty) ...[
            8.hS,
            Row(
              children: [
                Icon(
                  Icons.delivery_dining_outlined,
                  size: 14.r,
                  color: AppColor.slateGrey,
                ),
                6.wS,
                Text(
                  'Expected:',
                  style: AppFont.style(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.slateGrey,
                  ),
                ),
                6.wS,
                Expanded(
                  child: Text(
                    formattedDelivery,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: AppFont.style(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.charcoal,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ── Customer Note ─────────────────────────────────────
          if (order.note != null && order.note!.trim().isNotEmpty) ...[
            12.hS,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColor.orangeTint2.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColor.border.withValues(alpha: 0.7),
                  width: 1.r,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 15.r,
                    color: AppColor.primaryDark,
                  ),
                  6.wS,
                  Expanded(
                    child: Text(
                      'Note: ${order.note!}',
                      softWrap: true,
                      style: AppFont.style(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.r),
      ),
      child: Text(
        _formatStatus(status),
        style: AppFont.style(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'DELIVERED':
        return AppColor.green;
      case 'REJECTED':
      case 'CANCELLED':
        return AppColor.bright_red;
      case 'PENDING':
        return AppColor.secondary;
      case 'PREPARING':
        return AppColor.primary;
      case 'READY':
        return AppColor.green;
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
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final day = dt.day.toString().padLeft(2, '0');
      final month = _monthShort(dt.month);
      final year = dt.year;
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day $month $year, $hour:$minute $period';
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
