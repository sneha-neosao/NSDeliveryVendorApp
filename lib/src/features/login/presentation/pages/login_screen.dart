import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../../widgets/snackbar_widget.dart';
import '../bloc/auth_login_bloc/auth_login_bloc.dart';
import '../bloc/auth_login_form/auth_login_form_bloc.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/auth_forgot_password_widget.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/auth_login_button_widget.dart';
import '../widgets/auth_logo_widget.dart';
import '../widgets/auth_register_footer_widget.dart';
import '../widgets/login_input_widget.dart';

/// Login Screen displaying the authentication interface and calling the login API via Dual-BLoC.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _login(BuildContext context) {
    primaryFocus?.unfocus();
    final authForm = context.read<AuthLoginFormBloc>().state;

    context.read<AuthLoginBloc>().add(
          AuthLoginEvent(
            authForm.email.trim(),
            authForm.password.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthLoginFormBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthLoginBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<ThemeBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<TranslateBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        body: AuthBackgroundWidget(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                top: topPadding + 36.h,
                bottom: bottomPadding + 24.h,
                left: 24.w,
                right: 24.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Logo & Brand Name
                  const AuthLogoWidget(),
                  36.hS,

                  // Welcome Back Greeting
                  const AuthHeaderWidget(),
                  32.hS,

                  // Inputs (Email & Password Form Fields)
                  const LoginInputWidget(),
                  8.hS,

                  // Forgot Password Link
                  AuthForgotPasswordWidget(
                    onTap: () {
                      appSnackBar(
                        context,
                        AppColor.primary,
                        'Forgot password feature coming soon',
                      );
                    },
                  ),
                  28.hS,

                  // Login Button with BlocConsumer
                  BlocConsumer<AuthLoginBloc, AuthLoginState>(
                    listener: (context, state) {
                      if (state is AuthLoginSuccessState) {
                        appSnackBar(
                          context,
                          AppColor.green,
                          state.data.message ?? "Login successfully",
                        );
                        context.go(AppRoute.dashboard.path);
                      } else if (state is AuthLoginFailureState) {
                        appSnackBar(
                          context,
                          AppColor.bright_red,
                          state.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoginLoadingState;

                      return AuthLoginButtonWidget(
                        isLoading: isLoading,
                        onPressed: () => _login(context),
                      );
                    },
                  ),
                  24.hS,

                  // Register Link
                  AuthRegisterFooterWidget(
                    onRegisterTap: () {
                      appSnackBar(
                        context,
                        AppColor.primary,
                        'Registration feature coming soon',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
