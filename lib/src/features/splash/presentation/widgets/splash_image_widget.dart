import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

/// Modular widget displaying the full-screen splash image asset.
class SplashImageWidget extends StatefulWidget {
  const SplashImageWidget({super.key});

  @override
  State<SplashImageWidget> createState() => _SplashImageWidgetState();
}

class _SplashImageWidgetState extends State<SplashImageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColor.white,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Image.asset(
          'assets/images/splash_img.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
