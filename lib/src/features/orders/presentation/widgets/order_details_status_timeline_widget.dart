import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/order_details_model/order_details_response.dart';

class OrderDetailsStatusTimelineWidget extends StatelessWidget {
  final List<OrderStatusLog> logs;

  const OrderDetailsStatusTimelineWidget({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

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
            children: [
              Icon(
                Icons.timeline_rounded,
                size: 18.r,
                color: AppColor.primary,
              ),
              8.wS,
              Text(
                'Order Activity Timeline',
                style: AppFont.style(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.charcoal,
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

          // ── Timeline Items ────────────────────────────────────
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              final isLast = index == logs.length - 1;
              final statusColor = _statusColor(log.toStatus);
              final formattedTime = _formatDate(log.createdAt);

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator column
                    Column(
                      children: [
                        Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                            border: Border.all(
                              color: AppColor.pureWhite,
                              width: 2.r,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2.r,
                              color: AppColor.border.withValues(alpha: 0.8),
                            ),
                          ),
                      ],
                    ),
                    12.wS,

                    // Content column
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  log.toStatus ?? '—',
                                  style: AppFont.style(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                                Text(
                                  formattedTime,
                                  style: AppFont.style(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.slateGrey,
                                  ),
                                ),
                              ],
                            ),
                            if (log.changedBy != null &&
                                log.changedBy!.isNotEmpty) ...[
                              2.hS,
                              Text(
                                'By: ${log.changedBy!}',
                                softWrap: true,
                                style: AppFont.style(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.slateGrey,
                                ),
                              ),
                            ],
                            if (log.note != null &&
                                log.note!.trim().isNotEmpty) ...[
                              4.hS,
                              Text(
                                log.note!,
                                softWrap: true,
                                style: AppFont.style(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.charcoal,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      final day = dt.day.toString().padLeft(2, '0');
      final month = _monthShort(dt.month);
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
