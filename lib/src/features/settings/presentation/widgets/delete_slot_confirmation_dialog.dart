import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/slots_model/slots_list_response.dart';
import '../../bloc/slot_delete_bloc/slot_delete_bloc.dart';
import '../../../widgets/app_alert_dialogue_widget.dart';
import '../../../widgets/snackbar_widget.dart';

class DeleteSlotConfirmationDialog extends StatelessWidget {
  final SlotItem slot;
  final VoidCallback? onSlotDeleted;

  const DeleteSlotConfirmationDialog({
    super.key,
    required this.slot,
    this.onSlotDeleted,
  });

  static Future<void> show(
    BuildContext context, {
    required SlotItem slot,
    VoidCallback? onSlotDeleted,
  }) {
    final slotDeleteBloc = context.read<SlotDeleteBloc>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColor.black.withValues(alpha: 0.5),
      builder: (dialogContext) => BlocProvider.value(
        value: slotDeleteBloc,
        child: DeleteSlotConfirmationDialog(
          slot: slot,
          onSlotDeleted: onSlotDeleted,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final day = slot.dayOfWeek ?? 'this';

    return BlocConsumer<SlotDeleteBloc, SlotDeleteState>(
      listener: (context, state) {
        if (state is SlotDeleteSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();
          appSnackBar(
            context,
            AppColor.green,
            state.data.message ?? 'Restaurant slot deleted successfully',
          );
          onSlotDeleted?.call();
        } else if (state is SlotDeleteFailureState) {
          appSnackBar(context, AppColor.bright_red, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is SlotDeleteLoadingState;

        return AppAlertDialogWidget(
          title: 'Delete Time Slot',
          subtitle:
              'Are you sure you want to delete the time slot for $day? This action cannot be undone.',
          confirmText: 'Delete',
          cancelText: 'Cancel',
          icon: Icons.delete_outline_rounded,
          iconBgColor: AppColor.bright_red.withValues(alpha: 0.1),
          iconColor: AppColor.bright_red,
          confirmBtnColor: AppColor.bright_red,
          isLoading: isLoading,
          showCloseIcon: false,
          onConfirm: () {
            context
                .read<SlotDeleteBloc>()
                .add(DeleteSlotEvent(uuId: slot.uuId ?? ''));
          },
          onCancel: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
      },
    );
  }
}
