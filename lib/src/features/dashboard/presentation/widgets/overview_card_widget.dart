import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class OverviewCardWidget extends StatelessWidget {
  final bool isLoading;
  final String dateText;
  final int liveActiveOrders;
  final int totalMenuItems;
  final num partnerRating;
  final VoidCallback? onLiveOrdersTap;
  final VoidCallback? onMenuItemsTap;
  final VoidCallback? onRetryTap;
  final String? errorMessage;

  const OverviewCardWidget({
    super.key,
    this.isLoading = false,
    this.dateText = '',
    this.liveActiveOrders = 0,
    this.totalMenuItems = 0,
    this.partnerRating = 0,
    this.onLiveOrdersTap,
    this.onMenuItemsTap,
    this.onRetryTap,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: AppColor.bright_red.withValues(alpha: 0.2),
            width: 1.r,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColor.bright_red,
              size: 36.r,
            ),
            10.hS,
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: AppFont.style(
                color: AppColor.charcoal,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            14.hS,
            GestureDetector(
              onTap: onRetryTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColor.orangeTint2,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Retry',
                  style: AppFont.style(
                    color: AppColor.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.5),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Title & Date ──────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.green,
                    ),
                  ),
                  8.wS,
                  Text(
                    "Store Overview",
                    style: AppFont.style(
                      color: AppColor.charcoal,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (dateText.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColor.whiteShade,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColor.border.withValues(alpha: 0.4),
                      width: 1.r,
                    ),
                  ),
                  child: Text(
                    dateText,
                    style: AppFont.style(
                      color: AppColor.slateGrey,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          16.hS,

          // ── 1. Featured Live Active Orders Card ────────────────────
          GestureDetector(
            onTap: onLiveOrdersTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.orangeTint2,
                    AppColor.orangeTint,
                  ],
                ),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColor.primary.withValues(alpha: 0.25),
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: AppColor.pureWhite,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primary.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: AppColor.primary,
                      size: 26.r,
                    ),
                  ),
                  14.wS,

                  // Label & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Active Orders',
                          style: AppFont.style(
                            color: AppColor.charcoal,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        2.hS,
                        Text(
                          'Tap to view running orders',
                          style: AppFont.style(
                            color: AppColor.primary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Value / Loader
                  if (isLoading)
                    SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColor.primary,
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '$liveActiveOrders',
                        style: AppFont.style(
                          color: AppColor.pureWhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          14.hS,

          // ── 2. Row: Total Menu Items & Partner Rating ─────────────
          Row(
            children: [
              // Total Menu Items Card
              Expanded(
                child: GestureDetector(
                  onTap: onMenuItemsTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColor.whiteShade,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: AppColor.border.withValues(alpha: 0.6),
                        width: 1.r,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 36.r,
                              height: 36.r,
                              decoration: BoxDecoration(
                                color: AppColor.orangeTint2,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.restaurant_menu_rounded,
                                color: AppColor.primary,
                                size: 20.r,
                              ),
                            ),
                            if (isLoading)
                              SizedBox(
                                width: 16.r,
                                height: 16.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: AppColor.primary,
                                ),
                              )
                            else
                              Text(
                                '$totalMenuItems',
                                style: AppFont.style(
                                  color: AppColor.charcoal,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                          ],
                        ),
                        10.hS,
                        Text(
                          'Menu Items',
                          style: AppFont.style(
                            color: AppColor.charcoal,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        2.hS,
                        Text(
                          'Total dishes listed',
                          style: AppFont.style(
                            color: AppColor.slateGrey,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              12.wS,

              // Partner Rating Card
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColor.whiteShade,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: AppColor.border.withValues(alpha: 0.6),
                      width: 1.r,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: BoxDecoration(
                              color: AppColor.orangeTint2,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              color: AppColor.primary,
                              size: 22.r,
                            ),
                          ),
                          if (isLoading)
                            SizedBox(
                              width: 16.r,
                              height: 16.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: AppColor.primary,
                              ),
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  partnerRating.toStringAsFixed(1),
                                  style: AppFont.style(
                                    color: AppColor.charcoal,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                2.wS,
                                Icon(
                                  Icons.star_rounded,
                                  color: AppColor.primary,
                                  size: 16.r,
                                ),
                              ],
                            ),
                        ],
                      ),
                      10.hS,
                      Text(
                        'Partner Rating',
                        style: AppFont.style(
                          color: AppColor.charcoal,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      2.hS,
                      Text(
                        'Customer reviews',
                        style: AppFont.style(
                          color: AppColor.slateGrey,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
