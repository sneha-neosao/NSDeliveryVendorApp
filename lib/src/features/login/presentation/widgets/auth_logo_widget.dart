import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

/// Top branding widget featuring the custom food cloche icon and NeoSao Delivery Partner title.
class AuthLogoWidget extends StatelessWidget {
  const AuthLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Cloche Dome Graphic
        CustomPaint(
          size: Size(86.w, 64.h),
          painter: const _ClochePainter(),
        ),
        16.hS,
        // Brand Title
        Text(
          'NEOSAO',
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColor.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
        ),
        4.hS,
        // Sub-brand Title
        Text(
          'DELIVERY PARTNER',
          softWrap: true,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColor.primary,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
        ),
      ],
    );
  }
}

/// Custom painter for the vibrant orange food cloche icon with handle, shine highlight, and base rim.
class _ClochePainter extends CustomPainter {
  const _ClochePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = AppColor.primary
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final shinePaint = Paint()
      ..color = AppColor.pureWhite.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    final centerX = w / 2;
    final baseY = h - 6.0;

    // 1. Top Knob / Handle
    final handleCenter = Offset(centerX, 8.0);
    canvas.drawCircle(handleCenter, 6.0, primaryPaint);

    // Handle neck
    final neckRect = Rect.fromCenter(
      center: Offset(centerX, 13.0),
      width: 5.0,
      height: 6.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(neckRect, const Radius.circular(2.0)),
      primaryPaint,
    );

    // 2. Dome Body
    final domePath = Path();
    final domeLeft = centerX - 34.0;
    final domeRight = centerX + 34.0;
    final domeTopY = 15.0;

    domePath.moveTo(domeLeft, baseY);
    domePath.cubicTo(
      domeLeft,
      domeTopY + 2.0,
      domeRight,
      domeTopY + 2.0,
      domeRight,
      baseY,
    );
    domePath.close();

    canvas.drawPath(domePath, primaryPaint);

    // 3. Curved White Shine Highlight on Dome
    final shinePath = Path();
    shinePath.moveTo(centerX - 24.0, baseY - 8.0);
    shinePath.cubicTo(
      centerX - 24.0,
      domeTopY + 12.0,
      centerX - 10.0,
      domeTopY + 5.0,
      centerX - 6.0,
      domeTopY + 6.0,
    );
    canvas.drawPath(shinePath, shinePaint);

    // 4. Base Rim / Serving Tray Line
    final baseRimRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - 37.0, baseY, 74.0, 5.5),
      const Radius.circular(3.0),
    );
    canvas.drawRRect(baseRimRect, primaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
