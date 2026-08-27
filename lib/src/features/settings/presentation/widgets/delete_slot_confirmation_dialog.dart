import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/slots_model/slots_list_response.dart';
import '../../../widgets/app_alert_dialogue_widget.dart';

class DeleteSlotConfirmationDialog extends StatelessWidget {
  final SlotItem slot;
  final VoidCallback? onConfirmDelete;

  const DeleteSlotConfirmationDialog({
    super.key,
    required this.slot,
    this.onConfirmDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required SlotItem slot,
    VoidCallback? onConfirmDelete,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColor.black.withValues(alpha: 0.5),
      builder: (dialogContext) => DeleteSlotConfirmationDialog(
        slot: slot,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final day = slot.dayOfWeek ?? 'this';

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
      showCloseIcon: false,
      onConfirm: () {
        Navigator.of(context, rootNavigator: true).pop();
        onConfirmDelete?.call();
      },
      onCancel: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }
}
