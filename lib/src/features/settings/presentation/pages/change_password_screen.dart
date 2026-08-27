import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/app_button_widget.dart';
import '../widgets/change_password_header_widget.dart';
import '../widgets/change_password_input_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdatePassword() {
    primaryFocus?.unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      // Hook for update password API execution
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
            const ChangePasswordHeaderWidget(
              title: 'Change Password',
              subtitle: 'Update your account security password',
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
                      // Form Input Card
                      ChangePasswordInputWidget(
                        oldPasswordController: _oldPasswordController,
                        newPasswordController: _newPasswordController,
                        confirmPasswordController: _confirmPasswordController,
                      ),
                      28.hS,

                      // Update Password App Button
                      AppButtonWidget(
                        text: 'Update Password',
                        isLoading: _isLoading,
                        onPressed: _handleUpdatePassword,
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
