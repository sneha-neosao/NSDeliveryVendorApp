import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OrdersHeaderWidget extends StatelessWidget {
  final String title;
  final int ongoingCount;

  const OrdersHeaderWidget({
    super.key,
    this.title = 'Orders',
    this.ongoingCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 14.h,
        left: 20.w,
        right: 20.w,
        bottom: 18.h,
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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkOrange.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Screen Title
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  softWrap: true,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColor.pureWhite,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (ongoingCount > 0) ...[
                  8.wS,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.pureWhite.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColor.pureWhite.withValues(alpha: 0.4),
                        width: 1.r,
                      ),
                    ),
                    child: Text(
                      '$ongoingCount Active',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColor.pureWhite,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Decorative / Quick Action Bag Icon
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.pureWhite.withValues(alpha: 0.18),
              border: Border.all(
                color: AppColor.pureWhite.withValues(alpha: 0.3),
                width: 1.r,
              ),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColor.pureWhite,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}
