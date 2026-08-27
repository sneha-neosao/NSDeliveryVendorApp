import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/order_details_model/order_details_response.dart';

class OrderDetailsDeliveryBoyCardWidget extends StatelessWidget {
  final AssignedDeliveryBoy? deliveryBoy;

  const OrderDetailsDeliveryBoyCardWidget({
    super.key,
    required this.deliveryBoy,
  });

  @override
  Widget build(BuildContext context) {
    if (deliveryBoy == null ||
        deliveryBoy!.name == null ||
        deliveryBoy!.name!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final boy = deliveryBoy!;

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
                    Icons.two_wheeler_rounded,
                    size: 18.r,
                    color: AppColor.primary,
                  ),
                  8.wS,
                  Text(
                    'Delivery Partner',
                    style: AppFont.style(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.charcoal,
                    ),
                  ),
                ],
              ),
              if (boy.assignmentStatus != null &&
                  boy.assignmentStatus!.isNotEmpty)
                _buildBadge(boy.assignmentStatus),
            ],
          ),

          12.hS,

          Container(
            height: 1.h,
            color: AppColor.border.withValues(alpha: 0.5),
          ),

          12.hS,

          // ── Partner Info ──────────────────────────────────────
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.orangeTint2,
                ),
                child: Icon(
                  Icons.person_pin_rounded,
                  size: 22.r,
                  color: AppColor.primary,
                ),
              ),
              12.wS,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boy.name ?? '—',
                      softWrap: true,
                      style: AppFont.style(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.charcoal,
                      ),
                    ),
                    if (boy.phone != null && boy.phone!.isNotEmpty) ...[
                      2.hS,
                      Text(
                        boy.phone!,
                        softWrap: true,
                        style: AppFont.style(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.slateGrey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          if ((boy.vehicleType != null && boy.vehicleType!.isNotEmpty) ||
              (boy.vehicleNumber != null && boy.vehicleNumber!.isNotEmpty)) ...[
            12.hS,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.whiteShade,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_bike_rounded,
                    size: 14.r,
                    color: AppColor.slateGrey,
                  ),
                  6.wS,
                  Text(
                    '${boy.vehicleType?.toUpperCase() ?? ''} ${boy.vehicleNumber != null ? "• ${boy.vehicleNumber}" : ""}',
                    style: AppFont.style(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.slateGrey,
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

  Widget _buildBadge(String? status) {
    Color bg;
    Color fg;

    switch ((status ?? '').toUpperCase()) {
      case 'ACCEPTED':
        bg = AppColor.statusDeliveredBg;
        fg = AppColor.statusDelivered;
        break;
      case 'REJECTED':
        bg = AppColor.statusCancelledBg;
        fg = AppColor.statusCancelled;
        break;
      case 'ASSIGNED':
        bg = AppColor.statusConfirmedBg;
        fg = AppColor.statusConfirmed;
        break;
      case 'PENDING':
        bg = AppColor.statusPendingBg;
        fg = AppColor.statusPending;
        break;
      default:
        bg = AppColor.whiteShade;
        fg = AppColor.slateGrey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: fg.withValues(alpha: 0.35), width: 1.r),
      ),
      child: Text(
        status ?? '',
        style: AppFont.style(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}
