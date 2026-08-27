import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../../login/bloc/auth_login_bloc/auth_login_bloc.dart';
import '../widgets/splash_image_widget.dart';

/// Splash screen displayed when the application is launched.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _authCheckDone = false;
  bool _timerDone = false;
  bool _hasNavigated = false;
  AuthLoginState? _authState;

  @override
  void initState() {
    super.initState();
    _setSystemUIOverlay();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _timerDone = true;
        });
        _navigateIfReady();
      }
    });
  }

  void _navigateIfReady() {
    if (_authCheckDone && _timerDone && _authState != null && !_hasNavigated) {
      _hasNavigated = true;
      if (_authState is AuthCheckSignInStatusSuccessState) {
        context.goNamed(AppRoute.dashboard.name);
      } else {
        context.goNamed(AppRoute.login.name);
      }
    }
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<AuthLoginBloc>()..add(AuthCheckSignInStatusEvent()),
        ),
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: BlocListener<AuthLoginBloc, AuthLoginState>(
        listenWhen: (_, current) =>
            current is AuthCheckSignInStatusSuccessState ||
            current is AuthCheckSignInStatusFailureState,
        listener: (context, state) {
          if (mounted) {
            setState(() {
              _authCheckDone = true;
              _authState = state;
            });
            _navigateIfReady();
          }
        },
        child: const Scaffold(
          backgroundColor: AppColor.white,
          body: SplashImageWidget(),
        ),
      ),
    );
  }
}
