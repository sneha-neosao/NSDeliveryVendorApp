import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

/// Background widget that renders a clean background with subtle food doodle watermark.
class AuthBackgroundWidget extends StatelessWidget {
  final Widget child;

  const AuthBackgroundWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColor.whiteDark,
      child: Stack(
        children: [
          // Subtle Watermark Doodle Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              child: Image.asset(
                'assets/images/splash_img.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: child,
          ),
        ],
      ),
    );
  }
}
