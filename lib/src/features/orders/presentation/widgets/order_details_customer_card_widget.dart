import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/order_details_model/order_details_response.dart';

class OrderDetailsCustomerCardWidget extends StatelessWidget {
  final OrderDetailsData order;

  const OrderDetailsCustomerCardWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final delivery = order.deliveryDetails;
    final customerName = delivery?.name?.isNotEmpty == true
        ? delivery!.name!
        : (order.customerName ?? '—');
    final customerPhone = delivery?.phone?.isNotEmpty == true
        ? delivery!.phone!
        : (order.customerContact ?? '—');
    final address = delivery?.address ?? '—';
    final pincode = delivery?.pincode;
    final distance = order.deliveryDistanceKm;

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
          // ── Section Title ──────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.person_pin_circle_rounded,
                size: 18.r,
                color: AppColor.primary,
              ),
              8.wS,
              Text(
                'Customer & Delivery Details',
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

          // ── Customer Name & Phone ──────────────────────────────
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.whiteShade,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 18.r,
                  color: AppColor.primary,
                ),
              ),
              10.wS,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      softWrap: true,
                      style: AppFont.style(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.charcoal,
                      ),
                    ),
                    2.hS,
                    Text(
                      customerPhone,
                      softWrap: true,
                      style: AppFont.style(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.slateGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (order.customerEmail != null &&
              order.customerEmail!.trim().isNotEmpty) ...[
            8.hS,
            Row(
              children: [
                Icon(
                  Icons.mail_outline_rounded,
                  size: 14.r,
                  color: AppColor.slateGrey,
                ),
                6.wS,
                Expanded(
                  child: Text(
                    order.customerEmail!,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: AppFont.style(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.slateGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],

          12.hS,

          // ── Delivery Address ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColor.whiteShade,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColor.border.withValues(alpha: 0.6),
                width: 1.r,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16.r,
                      color: AppColor.primary,
                    ),
                    6.wS,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address',
                            style: AppFont.style(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.primaryDark,
                            ),
                          ),
                          4.hS,
                          Text(
                            address,
                            softWrap: true,
                            style: AppFont.style(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.charcoal,
                              height: 1.35,
                            ),
                          ),
                          if (pincode != null && pincode.isNotEmpty) ...[
                            4.hS,
                            Text(
                              'Pincode: $pincode',
                              style: AppFont.style(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.slateGrey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (distance != null && distance > 0) ...[
                  8.hS,
                  Row(
                    children: [
                      Icon(
                        Icons.route_outlined,
                        size: 14.r,
                        color: AppColor.slateGrey,
                      ),
                      6.wS,
                      Text(
                        'Distance: ${distance.toStringAsFixed(2)} km',
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
          ),
        ],
      ),
    );
  }
}
