import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../../../remote/models/offers_model/offers_list_response.dart';

class OfferCardWidget extends StatelessWidget {
  final OfferItem offer;
  final bool isLoading;
  final ValueChanged<bool>? onToggle;

  const OfferCardWidget({
    super.key,
    required this.offer,
    this.isLoading = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPercentile =
        (offer.couponType ?? '').toLowerCase() == 'percentile';
    final discountText = isPercentile
        ? '${offer.discValue?.toInt() ?? 0}% OFF'
        : '₹${offer.discValue?.toStringAsFixed(0) ?? '0'} OFF';

    final isActive = offer.isActive ?? false;
    final formattedExpiry = _formatExpiryDate(offer.expiryDate);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isActive
              ? AppColor.primary.withValues(alpha: 0.25)
              : AppColor.border.withValues(alpha: 0.7),
          width: 1.2.r,
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Header Banner with Coupon Code & Orange Toggle Switch ─────
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColor.orangeTint2
                      : AppColor.whiteShade,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Coupon Code Pill with Copy Action
                    GestureDetector(
                      onTap: () {
                        if (offer.couponCode != null &&
                            offer.couponCode!.isNotEmpty) {
                          Clipboard.setData(
                              ClipboardData(text: offer.couponCode!));
                          appSnackBar(
                            context,
                            AppColor.green,
                            'Coupon code "${offer.couponCode}" copied!',
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.pureWhite,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColor.primary.withValues(alpha: 0.5),
                            style: BorderStyle.solid,
                            width: 1.r,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.confirmation_number_outlined,
                              size: 14.r,
                              color: AppColor.primary,
                            ),
                            6.wS,
                            Text(
                              offer.couponCode ?? '—',
                              style: AppFont.style(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColor.primaryDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                            6.wS,
                            Icon(
                              Icons.copy_rounded,
                              size: 12.r,
                              color: AppColor.slateGrey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Orange Toggle Switch & Loader ──────────────────────
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          SizedBox(
                            width: 38.w,
                            height: 26.h,
                            child: Center(
                              child: SizedBox(
                                width: 18.r,
                                height: 18.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          )
                        else
                          Transform.scale(
                            scale: 0.78,
                            child: CupertinoSwitch(
                              value: isActive,
                              activeTrackColor: AppColor.primary,
                              inactiveTrackColor:
                                  AppColor.gray.withValues(alpha: 0.35),
                              onChanged: isLoading
                                  ? null
                                  : (val) => onToggle?.call(val),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Main Content Area ──────────────────────────────
              Padding(
                padding: EdgeInsets.all(14.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Discount Headline + Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          discountText,
                          softWrap: true,
                          style: AppFont.style(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColor.primary,
                          ),
                        ),
                        if (offer.capLimit != null && offer.capLimit! > 0)
                          Text(
                            'Up to ₹${offer.capLimit!.toStringAsFixed(0)}',
                            style: AppFont.style(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.slateGrey,
                            ),
                          ),
                      ],
                    ),

                    if (offer.title != null && offer.title!.trim().isNotEmpty) ...[
                      4.hS,
                      Text(
                        offer.title!,
                        softWrap: true,
                        style: AppFont.style(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.charcoal,
                        ),
                      ),
                    ],

                    if (offer.couponDescription != null &&
                        offer.couponDescription!.trim().isNotEmpty) ...[
                      6.hS,
                      Text(
                        offer.couponDescription!,
                        softWrap: true,
                        style: AppFont.style(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.slateGrey,
                          height: 1.3,
                        ),
                      ),
                    ],

                    12.hS,

                    // ── Info Grid / Badges ────────────────────────
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        // Min Order Value
                        _buildInfoPill(
                          icon: Icons.shopping_cart_outlined,
                          label:
                              'Min Order: ₹${offer.orderValue?.toStringAsFixed(0) ?? '0'}',
                        ),
                        // Per User Limit
                        if (offer.perUserLimit != null && offer.perUserLimit! > 0)
                          _buildInfoPill(
                            icon: Icons.person_outline_rounded,
                            label: 'Limit: ${offer.perUserLimit}/user',
                          ),
                        // Usage Count
                        _buildInfoPill(
                          icon: Icons.bar_chart_rounded,
                          label:
                              '${offer.totalUsed ?? 0}/${offer.useLimit ?? 0} Used',
                          highlight: true,
                        ),
                      ],
                    ),

                    12.hS,

                    // ── Divider ──────────────────────────────────
                    Container(
                      height: 1.h,
                      color: AppColor.border.withValues(alpha: 0.5),
                    ),

                    10.hS,

                    // ── Expiry / Remaining Uses Footer ────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 13.r,
                              color: AppColor.slateGrey,
                            ),
                            4.wS,
                            Text(
                              formattedExpiry.isNotEmpty
                              ? 'Valid till $formattedExpiry'
                              : 'No Expiry',
                              style: AppFont.style(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColor.slateGrey,
                              ),
                            ),
                          ],
                        ),
                        if (offer.remainingUses != null)
                          Text(
                            '${offer.remainingUses} left',
                            style: AppFont.style(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: offer.remainingUses! > 0
                                  ? AppColor.primaryDark
                                  : AppColor.bright_red,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Blurry Overlay with Loader when Toggling Status ──
          if (isLoading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    color: AppColor.pureWhite.withValues(alpha: 0.4),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: AppColor.pureWhite,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoPill({
    required IconData icon,
    required String label,
    bool highlight = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: highlight
            ? AppColor.orangeTint2
            : AppColor.whiteShade,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.r,
            color: highlight ? AppColor.primary : AppColor.slateGrey,
          ),
          4.wS,
          Text(
            label,
            style: AppFont.style(
              fontSize: 11.sp,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
              color: highlight ? AppColor.primaryDark : AppColor.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatExpiryDate(String? dateStr) {
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
