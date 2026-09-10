import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../../../remote/models/dashboard_model/revenue_analytics_response.dart';

/// Card widget displaying the "Today's Earnings" & "Revenue Analytics" line chart
/// with 7-day revenue trend and bottom order performance metrics,
/// accurately matching the user-provided design reference.
class WeeklyBusinessMovementWidget extends StatelessWidget {
  final bool isLoading;
  final RevenueAnalyticsData? analytics;
  final String? errorMessage;
  final VoidCallback? onRetryTap;

  const WeeklyBusinessMovementWidget({
    super.key,
    this.isLoading = false,
    this.analytics,
    this.errorMessage,
    this.onRetryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return _buildErrorState(context);
    }

    if (isLoading) {
      return _buildShimmerState(context);
    }

    final earnings = analytics?.weeklyEarnings ?? [];
    final todaySales = (analytics?.todaySales ?? 0).toDouble();

    // Calculate maximum sales among weekly days for chart scale
    double peak = 0;
    for (final item in earnings) {
      final s = (item.totalSales ?? 0).toDouble();
      if (s > peak) peak = s;
    }
    // Default to 150 if no sales, otherwise scale with headroom
    double maxVal = peak <= 0 ? 150.0 : (peak * 1.2);
    if (maxVal < 100) maxVal = 100;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.8),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Header Row ───────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Badge & Title
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.orangeTint2.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColor.orangeTint,
                          width: 1.r,
                        ),
                      ),
                      child: Text(
                        'REVENUE ANALYTICS',
                        style: AppFont.style(
                          color: AppColor.primary,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    6.hS,
                    Text(
                      "Today's Earnings",
                      style: AppFont.style(
                        color: AppColor.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Total Sales (Today)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TOTAL SALES (TODAY)',
                    style: AppFont.style(
                      color: AppColor.slateGrey,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  4.hS,
                  Text(
                    '₹${todaySales.toStringAsFixed(2)}',
                    style: AppFont.style(
                      color: AppColor.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          14.hS,

          // ── Divider ──────────────────────────────────────────────────
          Divider(
            height: 1.h,
            thickness: 1.r,
            color: AppColor.border.withValues(alpha: 0.5),
          ),
          12.hS,

          // ── 7-Day Revenue Line Chart Area ────────────────────────────
          SizedBox(
            height: 175.h,
            width: double.infinity,
            child: CustomPaint(
              painter: _RevenueLineChartPainter(
                earnings: earnings,
                maxVal: maxVal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColor.bright_red.withValues(alpha: 0.2),
          width: 1.r,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColor.bright_red,
            size: 32.r,
          ),
          8.hS,
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: AppFont.style(
              color: AppColor.charcoal,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          12.hS,
          GestureDetector(
            onTap: onRetryTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Retry',
                style: AppFont.style(
                  color: AppColor.pureWhite,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerState(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.whiteDark,
      highlightColor: AppColor.pureWhite,
      child: Container(
        width: double.infinity,
        height: 235.h,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: AppColor.border.withValues(alpha: 0.5),
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
                  width: 130.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColor.pureWhite,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                Container(
                  width: 100.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColor.pureWhite,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
            16.hS,
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.pureWhite,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter drawing the dashed Y-axis gridlines, left currency labels,
/// X-axis day labels, gradient fill, orange trend line, and hollow point circles.
class _RevenueLineChartPainter extends CustomPainter {
  final List<WeeklyEarningItem> earnings;
  final double maxVal;

  _RevenueLineChartPainter({
    required this.earnings,
    required this.maxVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 38.0;
    const rightMargin = 16.0;
    const topMargin = 12.0;
    const bottomMargin = 24.0;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;
    final yBottom = topMargin + chartHeight;
    final yTop = topMargin;
    final xStart = leftMargin;
    final xEnd = size.width - rightMargin;

    // ── 1. Dashed Gridlines & Left Y-Axis Labels ────────────────────────
    final gridLinePaint = Paint()
      ..color = AppColor.gray.withValues(alpha: 0.28)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final yLabelStyle = TextStyle(
      color: AppColor.gray,
      fontSize: 10.5.sp,
      fontWeight: FontWeight.w500,
    );

    const gridDivisions = 4; // 0%, 25%, 50%, 75%, 100%
    for (int i = 0; i <= gridDivisions; i++) {
      final ratio = i / gridDivisions;
      final y = yBottom - (ratio * chartHeight);
      final labelVal = (maxVal * ratio).round();

      // Draw horizontal dashed line
      _drawDashedLine(
        canvas: canvas,
        p1: Offset(xStart, y),
        p2: Offset(xEnd, y),
        paint: gridLinePaint,
        dashWidth: 4.0,
        dashSpace: 3.0,
      );

      // Draw left currency label (e.g. ₹150, ₹113, ₹75, ₹38, ₹0)
      final textSpan = TextSpan(
        text: '₹$labelVal',
        style: yLabelStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          xStart - textPainter.width - 6.w,
          y - (textPainter.height / 2),
        ),
      );
    }

    // If no earnings data, default to 7 empty days (Fri to Thu)
    final pointsData = earnings.isNotEmpty
        ? earnings
        : [
            WeeklyEarningItem(day: 'Fri', totalSales: 0),
            WeeklyEarningItem(day: 'Sat', totalSales: 0),
            WeeklyEarningItem(day: 'Sun', totalSales: 0),
            WeeklyEarningItem(day: 'Mon', totalSales: 0),
            WeeklyEarningItem(day: 'Tue', totalSales: 0),
            WeeklyEarningItem(day: 'Wed', totalSales: 0),
            WeeklyEarningItem(day: 'Thu', totalSales: 0),
          ];

    final count = pointsData.length;
    if (count < 2) return;

    final points = <Offset>[];
    for (int i = 0; i < count; i++) {
      final x = xStart + i * (chartWidth / (count - 1));
      final sales = (pointsData[i].totalSales ?? 0).toDouble();
      final ratio = (sales / maxVal).clamp(0.0, 1.0);
      final y = yBottom - (ratio * chartHeight);
      points.add(Offset(x, y));

      // Draw bottom X-axis day label (Fri, Sat, Sun, etc.)
      final dayStr = pointsData[i].day?.trim().isNotEmpty == true
          ? pointsData[i].day!.trim()
          : 'Day';

      final daySpan = TextSpan(
        text: dayStr,
        style: TextStyle(
          color: AppColor.slateGrey,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      );
      final dayPainter = TextPainter(
        text: daySpan,
        textDirection: TextDirection.ltr,
      )..layout();

      dayPainter.paint(
        canvas,
        Offset(
          x - (dayPainter.width / 2),
          yBottom + 7.h,
        ),
      );
    }

    // ── 2. Gradient Fill Under The Line ────────────────────────────────
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, yBottom);
    for (final pt in points) {
      fillPath.lineTo(pt.dx, pt.dy);
    }
    fillPath.lineTo(points.last.dx, yBottom);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColor.darkOrange.withValues(alpha: 0.28),
          AppColor.darkOrange.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTRB(xStart, yTop, xEnd, yBottom));

    canvas.drawPath(fillPath, fillPaint);

    // ── 3. Orange Stroke Line ──────────────────────────────────────────
    final strokePath = Path();
    strokePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      strokePath.lineTo(points[i].dx, points[i].dy);
    }

    final strokePaint = Paint()
      ..color = AppColor.darkOrange
      ..strokeWidth = 3.2.r
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(strokePath, strokePaint);

    // ── 4. Hollow Point Circles with White Fill & Orange Border ────────
    final circleFillPaint = Paint()
      ..color = AppColor.pureWhite
      ..style = PaintingStyle.fill;

    final circleStrokePaint = Paint()
      ..color = AppColor.darkOrange
      ..strokeWidth = 2.8.r
      ..style = PaintingStyle.stroke;

    for (final pt in points) {
      canvas.drawCircle(pt, 5.0.r, circleFillPaint);
      canvas.drawCircle(pt, 5.0.r, circleStrokePaint);
    }
  }

  void _drawDashedLine({
    required Canvas canvas,
    required Offset p1,
    required Offset p2,
    required Paint paint,
    required double dashWidth,
    required double dashSpace,
  }) {
    double startX = p1.dx;
    final y = p1.dy;
    final endX = p2.dx;

    while (startX < endX) {
      final currentDashWidth =
          (startX + dashWidth < endX) ? dashWidth : (endX - startX);
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + currentDashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueLineChartPainter oldDelegate) {
    return oldDelegate.earnings != earnings || oldDelegate.maxVal != maxVal;
  }
}
