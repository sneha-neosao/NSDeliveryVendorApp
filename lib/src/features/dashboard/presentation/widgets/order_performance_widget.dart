import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/dashboard_model/performance_metrics_response.dart';

class OrderPerformanceWidget extends StatelessWidget {
  final OrderPerformance? performance;
  final bool isLoading;

  const OrderPerformanceWidget({
    super.key,
    this.performance,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final total = performance?.totalOrders ?? 0;
    final completed = performance?.completedOrders ?? 0;
    final rejected = performance?.rejectedOrders ?? 0;

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
            color: AppColor.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColor.orangeTint2,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.insights_rounded,
                  color: AppColor.primary,
                  size: 18.r,
                ),
              ),
              10.wS,
              Expanded(
                child: Text(
                  'Order Performance',
                  softWrap: true,
                  style: AppFont.style(
                    color: AppColor.charcoal,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          16.hS,

          // ── 3 Metric Stats ───────────────────────────────────────
          Row(
            children: [
              // 1. Total Orders
              Expanded(
                child: _buildMetricTile(
                  title: 'Total',
                  count: '$total',
                  icon: Icons.receipt_outlined,
                  iconColor: AppColor.charcoal,
                  bgColor: AppColor.whiteShade,
                  isLoading: isLoading,
                ),
              ),
              10.wS,

              // 2. Completed Orders
              Expanded(
                child: _buildMetricTile(
                  title: 'Completed',
                  count: '$completed',
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppColor.green,
                  bgColor: AppColor.green.withValues(alpha: 0.08),
                  isLoading: isLoading,
                ),
              ),
              10.wS,

              // 3. Rejected Orders
              Expanded(
                child: _buildMetricTile(
                  title: 'Rejected',
                  count: '$rejected',
                  icon: Icons.cancel_outlined,
                  iconColor: AppColor.bright_red,
                  bgColor: AppColor.bright_red.withValues(alpha: 0.08),
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String count,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required bool isLoading,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.4),
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20.r,
          ),
          8.hS,
          if (isLoading)
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: iconColor,
              ),
            )
          else
            Text(
              count,
              softWrap: true,
              style: AppFont.style(
                color: AppColor.charcoal,
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          4.hS,
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFont.style(
              color: AppColor.slateGrey,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
