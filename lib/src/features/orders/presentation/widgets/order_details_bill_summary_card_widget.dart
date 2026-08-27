import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/order_details_model/order_details_response.dart';

class OrderDetailsBillSummaryCardWidget extends StatelessWidget {
  final OrderDetailsData order;

  const OrderDetailsBillSummaryCardWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final paymentColor = _paymentColor(order.paymentStatus);

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
                    Icons.receipt_rounded,
                    size: 18.r,
                    color: AppColor.primary,
                  ),
                  8.wS,
                  Text(
                    'Bill Summary',
                    style: AppFont.style(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.charcoal,
                    ),
                  ),
                ],
              ),
              // Payment Mode Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColor.orangeTint2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  order.paymentMode ?? '—',
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

          // ── Bill Items ────────────────────────────────────────
          _buildBillRow('Item Total', '₹${(order.totalAmount ?? 0).toStringAsFixed(0)}'),

          if ((order.packingCharge ?? 0) > 0) ...[
            8.hS,
            _buildBillRow('Packing Charges', '₹${order.packingCharge!.toStringAsFixed(0)}'),
          ],

          if ((order.platformCharges ?? 0) > 0) ...[
            8.hS,
            _buildBillRow('Platform Charges', '₹${order.platformCharges!.toStringAsFixed(0)}'),
          ],

          if ((order.deliveryCharge ?? 0) > 0) ...[
            8.hS,
            _buildBillRow('Delivery Charges', '₹${order.deliveryCharge!.toStringAsFixed(0)}'),
          ],

          if ((order.couponDiscount ?? 0) > 0) ...[
            8.hS,
            _buildBillRow(
              'Coupon Discount${order.couponCode != null ? " (${order.couponCode})" : ""}',
              '- ₹${order.couponDiscount!.toStringAsFixed(0)}',
              isDiscount: true,
            ),
          ],

          if ((order.walletDiscountAmount ?? 0) > 0) ...[
            8.hS,
            _buildBillRow(
              'Wallet Discount',
              '- ₹${order.walletDiscountAmount!.toStringAsFixed(0)}',
              isDiscount: true,
            ),
          ],

          12.hS,

          Container(
            height: 1.h,
            color: AppColor.border.withValues(alpha: 0.5),
          ),

          12.hS,

          // ── Grand Total ───────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: AppFont.style(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColor.charcoal,
                ),
              ),
              Text(
                '₹${(order.grandTotal ?? 0).toStringAsFixed(0)}',
                style: AppFont.style(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),

          12.hS,

          // ── Payment Status Banner ─────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: paymentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: paymentColor.withValues(alpha: 0.3),
                width: 1.r,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      size: 15.r,
                      color: paymentColor,
                    ),
                    6.wS,
                    Text(
                      'Payment Status',
                      style: AppFont.style(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.charcoal,
                      ),
                    ),
                  ],
                ),
                Text(
                  order.paymentStatus ?? '—',
                  style: AppFont.style(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: paymentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            softWrap: true,
            style: AppFont.style(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDiscount ? AppColor.green : AppColor.slateGrey,
            ),
          ),
        ),
        8.wS,
        Text(
          value,
          style: AppFont.style(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColor.green : AppColor.charcoal,
          ),
        ),
      ],
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
}
