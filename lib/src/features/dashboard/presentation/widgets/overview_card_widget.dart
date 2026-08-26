import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class OverviewCardWidget extends StatelessWidget {
  final String dateText;
  final String ordersCount;
  final String revenueAmount;
  final String preparingCount;
  final String completedCount;

  const OverviewCardWidget({
    super.key,
    this.dateText = '25 May 2024',
    this.ordersCount = '18',
    this.revenueAmount = '₹ 4,350',
    this.preparingCount = '6',
    this.completedCount = '12',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Title & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Overview",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColor.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                dateText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColor.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          16.hS,
          // Row 1: Orders & Revenue
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context: context,
                  label: 'Orders',
                  value: ordersCount,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  context: context,
                  label: 'Revenue',
                  value: revenueAmount,
                ),
              ),
            ],
          ),
          14.hS,
          Divider(
            color: AppColor.border.withValues(alpha: 0.5),
            height: 1.h,
            thickness: 1.h,
          ),
          14.hS,
          // Row 2: Preparing & Completed
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context: context,
                  label: 'Preparing',
                  value: preparingCount,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  context: context,
                  label: 'Completed',
                  value: completedCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          softWrap: true,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
        ),
        4.hS,
        Text(
          value,
          softWrap: true,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColor.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
