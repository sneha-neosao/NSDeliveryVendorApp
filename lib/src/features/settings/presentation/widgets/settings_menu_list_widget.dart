import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import 'settings_menu_item_widget.dart';

class SettingsMenuListWidget extends StatelessWidget {
  final bool isServiceOn;
  final bool isServiceabilityLoading;
  final ValueChanged<bool>? onServiceabilityChanged;
  final VoidCallback? onTimeSlotsTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onDeleteAccountTap;

  const SettingsMenuListWidget({
    super.key,
    this.isServiceOn = true,
    this.isServiceabilityLoading = false,
    this.onServiceabilityChanged,
    this.onTimeSlotsTap,
    this.onLogoutTap,
    this.onDeleteAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Serviceability with Toggle Switch & Loading Spinner
        SettingsMenuItemWidget(
          icon: Icons.room_service_rounded,
          title: 'Serviceability',
          subtitle: 'Turn your service ON/OFF',
          onTap: isServiceabilityLoading
              ? null
              : () => onServiceabilityChanged?.call(!isServiceOn),
          trailing: isServiceabilityLoading
              ? SizedBox(
                  width: 44.w,
                  height: 28.h,
                  child: Center(
                    child: SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                )
              : CupertinoSwitch(
                  value: isServiceOn,
                  activeTrackColor: AppColor.primary,
                  inactiveTrackColor: AppColor.gray.withValues(alpha: 0.35),
                  onChanged: isServiceabilityLoading
                      ? null
                      : onServiceabilityChanged,
                ),
        ),
        14.hS,

        // 2. Time Slots with Clock Icon
        SettingsMenuItemWidget(
          icon: Icons.access_time_rounded,
          title: 'Time Slots',
          subtitle: 'Add and manage your time slots',
          onTap: onTimeSlotsTap,
        ),
        14.hS,

        // 3. Logout (No Arrow)
        SettingsMenuItemWidget(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'Sign out from your account',
          showTrailing: false,
          onTap: onLogoutTap,
        ),
        14.hS,

        // 4. Delete Account (No Arrow)
        SettingsMenuItemWidget(
          icon: Icons.delete_outline_rounded,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          showTrailing: false,
          iconColor: AppColor.bright_red,
          iconBackgroundColor: AppColor.bright_red.withValues(alpha: 0.1),
          titleColor: AppColor.bright_red,
          onTap: onDeleteAccountTap,
        ),
      ],
    );
  }
}
