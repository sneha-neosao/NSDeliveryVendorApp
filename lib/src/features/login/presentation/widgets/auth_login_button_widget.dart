import 'package:flutter/material.dart';
import '../../../widgets/app_button_widget.dart';

/// Primary action button for submitting login credentials.
class AuthLoginButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const AuthLoginButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Login',
  });

  @override
  Widget build(BuildContext context) {
    return AppButtonWidget(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
