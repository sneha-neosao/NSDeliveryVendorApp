import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/app_button_widget.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../bloc/forgot_password_bloc/forgot_password_bloc.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext blocContext) {
    primaryFocus?.unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      blocContext.read<ForgotPasswordBloc>().add(
            SubmitForgotPasswordEvent(
              email: _emailController.text.trim(),
            ),
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
        BlocProvider(create: (_) => getIt<ForgotPasswordBloc>()),
      ],
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
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
                      bottom: 16.h,
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

                          // Send Reset Link Button with BlocConsumer
                          BlocConsumer<ForgotPasswordBloc,
                              ForgotPasswordState>(
                            listener: (context, state) {
                              if (state is ForgotPasswordSuccessState) {
                                appSnackBar(
                                  context,
                                  AppColor.green,
                                  state.data.message ??
                                      'Reset link has been sent to your email.',
                                );
                                context.pop();
                              } else if (state is ForgotPasswordFailureState) {
                                appSnackBar(
                                  context,
                                  AppColor.bright_red,
                                  state.message,
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading =
                                  state is ForgotPasswordLoadingState;

                              return AppButtonWidget(
                                text: 'Send Reset Link',
                                isLoading: isLoading,
                                onPressed: () => _handleSubmit(blocContext),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
