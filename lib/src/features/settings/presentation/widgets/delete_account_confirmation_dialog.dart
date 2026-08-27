import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../../widgets/app_alert_dialogue_widget.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../bloc/delete_account_bloc/delete_account_bloc.dart';

class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({super.key});

  static Future<void> show(BuildContext context) {
    final deleteAccountBloc = context.read<DeleteAccountBloc>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColor.black.withValues(alpha: 0.5),
      builder: (dialogContext) => BlocProvider.value(
        value: deleteAccountBloc,
        child: const DeleteAccountConfirmationDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();
          appSnackBar(
            context,
            AppColor.green,
            state.data.message?.isNotEmpty == true
                ? state.data.message!
                : "Restaurant account deleted successfully",
          );
          context.go(AppRoute.login.path);
        } else if (state is DeleteAccountFailureState) {
          appSnackBar(
            context,
            AppColor.bright_red,
            state.message,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DeleteAccountLoadingState;

        return AppAlertDialogWidget(
          title: 'Delete Account',
          subtitle:
              'Are you sure you want to permanently delete your restaurant account? All your data will be erased and this action cannot be undone.',
          confirmText: 'Delete',
          cancelText: 'Cancel',
          icon: Icons.delete_forever_rounded,
          iconBgColor: AppColor.bright_red.withValues(alpha: 0.1),
          iconColor: AppColor.bright_red,
          confirmBtnColor: AppColor.bright_red,
          isLoading: isLoading,
          showCloseIcon: false,
          onConfirm: () {
            context.read<DeleteAccountBloc>().add(DeleteAccountSubmitEvent());
          },
        );
      },
    );
  }
}
