import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../../login/presentation/bloc/auth_login_bloc/auth_login_bloc.dart';
import '../../../widgets/app_alert_dialogue_widget.dart';
import '../../../widgets/snackbar_widget.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  static Future<void> show(BuildContext context) {
    final authLoginBloc = context.read<AuthLoginBloc>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColor.black.withValues(alpha: 0.5),
      builder: (dialogContext) => BlocProvider.value(
        value: authLoginBloc,
        child: const LogoutConfirmationDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthLoginBloc, AuthLoginState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();
          appSnackBar(
            context,
            AppColor.green,
            state.data.message.isNotEmpty
                ? state.data.message
                : "Logged out successfully",
          );
          context.go(AppRoute.login.path);
        } else if (state is AuthLogoutFailureState) {
          appSnackBar(
            context,
            AppColor.bright_red,
            state.message,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLogoutLoadingState;

        return AppAlertDialogWidget(
          title: 'Logout',
          subtitle: 'Are you sure you want to log out from your account?',
          confirmText: 'Logout',
          cancelText: 'Cancel',
          icon: Icons.logout_rounded,
          iconBgColor: AppColor.orangeTint2,
          iconColor: AppColor.primary,
          confirmBtnColor: AppColor.primary,
          isLoading: isLoading,
          showCloseIcon: false,
          onConfirm: () {
            context.read<AuthLoginBloc>().add(AuthLogoutEvent());
          },
        );
      },
    );
  }
}
