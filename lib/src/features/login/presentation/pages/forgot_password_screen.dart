import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/app_button_widget.dart';
import '../../../widgets/snackbar_widget.dart';
import '../widgets/forgot_password_header_widget.dart';
import '../widgets/forgot_password_input_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    primaryFocus?.unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      // Hook for forgot password API submission
      appSnackBar(
        context,
        AppColor.green,
        'Password reset link will be sent to your email',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // ── Top Header ──────────────────────────────────────────
            const ForgotPasswordHeaderWidget(
              title: 'Forgot Password',
              subtitle: 'Enter your email to receive password reset link',
            ),

            // ── Scrollable Form Body ────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 20.h,
                  bottom: bottomPadding > 0 ? bottomPadding + 24.h : 30.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input Card
                      ForgotPasswordInputWidget(
                        emailController: _emailController,
                      ),
                      28.hS,

                      // Send Reset Link Button
                      AppButtonWidget(
                        text: 'Send Reset Link',
                        borderRadius: 16.r,
                        height: 50.h,
                        isLoading: _isLoading,
                        onPressed: _handleSubmit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
