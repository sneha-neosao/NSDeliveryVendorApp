import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/slots_model/slots_list_response.dart';

class SlotCardWidget extends StatelessWidget {
  final SlotItem slot;

  const SlotCardWidget({
    super.key,
    required this.slot,
  });

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return '--:--';
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        if (hour > 12) hour -= 12;
        if (hour == 0) hour = 12;
        final hourStr = hour.toString().padLeft(2, '0');
        return '$hourStr:$minute $period';
      }
    } catch (_) {}
    return timeStr;
  }

  @override
  Widget build(BuildContext context) {
    final isActive = slot.isActive == true;
    final formattedStart = _formatTime(slot.startTime);
    final formattedEnd = _formatTime(slot.endTime);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.5),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Day Badge + Active/Inactive Status Chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Day of Week
                Row(
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: AppColor.orangeTint2,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        color: AppColor.primary,
                        size: 18.r,
                      ),
                    ),
                    10.wS,
                    Text(
                      slot.dayOfWeek ?? 'Unknown Day',
                      style: AppFont.style(
                        color: AppColor.charcoal,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                // Status Chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColor.statusDeliveredBg
                        : AppColor.gray.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColor.statusDelivered
                              : AppColor.slateGrey,
                        ),
                      ),
                      6.wS,
                      Text(
                        isActive ? 'Active' : 'Inactive',
                        style: AppFont.style(
                          color: isActive
                              ? AppColor.statusDelivered
                              : AppColor.slateGrey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.hS,

            // Divider
            Divider(
              height: 1.h,
              thickness: 1.r,
              color: AppColor.border.withValues(alpha: 0.4),
            ),
            12.hS,

            // Row 2: Time Range Display
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColor.whiteShade,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColor.border.withValues(alpha: 0.3),
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: AppColor.primary,
                    size: 18.r,
                  ),
                  8.wS,
                  Text(
                    'Time Slot:',
                    style: AppFont.style(
                      color: AppColor.slateGrey,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.wS,
                  Expanded(
                    child: Text(
                      '$formattedStart  —  $formattedEnd',
                      style: AppFont.style(
                        color: AppColor.charcoal,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
