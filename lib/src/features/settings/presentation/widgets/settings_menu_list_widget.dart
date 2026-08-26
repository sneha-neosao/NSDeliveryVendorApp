import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import 'settings_menu_item_widget.dart';

class SettingsMenuListWidget extends StatefulWidget {
  final ValueChanged<bool>? onServiceabilityChanged;
  final VoidCallback? onTimeSlotsTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onDeleteAccountTap;
  final bool initialServiceability;

  const SettingsMenuListWidget({
    super.key,
    this.onServiceabilityChanged,
    this.onTimeSlotsTap,
    this.onLogoutTap,
    this.onDeleteAccountTap,
    this.initialServiceability = true,
  });

  @override
  State<SettingsMenuListWidget> createState() => _SettingsMenuListWidgetState();
}

class _SettingsMenuListWidgetState extends State<SettingsMenuListWidget> {
  late bool _isServiceOn;

  @override
  void initState() {
    super.initState();
    _isServiceOn = widget.initialServiceability;
  }

  void _toggleServiceability(bool value) {
    setState(() {
      _isServiceOn = value;
    });
    widget.onServiceabilityChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Serviceability with Toggle Switch
        SettingsMenuItemWidget(
          icon: Icons.room_service_rounded,
          title: 'Serviceability',
          subtitle: 'Turn your service ON/OFF',
          onTap: () => _toggleServiceability(!_isServiceOn),
          trailing: CupertinoSwitch(
            value: _isServiceOn,
            activeTrackColor: AppColor.primary,
            inactiveTrackColor: AppColor.gray.withValues(alpha: 0.35),
            onChanged: _toggleServiceability,
          ),
        ),
        14.hS,

        // 2. Time Slots with Clock Icon
        SettingsMenuItemWidget(
          icon: Icons.access_time_rounded,
          title: 'Time Slots',
          subtitle: 'Add and manage your time slots',
          onTap: widget.onTimeSlotsTap,
        ),
        14.hS,

        // 3. Logout (No Arrow)
        SettingsMenuItemWidget(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'Sign out from your account',
          showTrailing: false,
          onTap: widget.onLogoutTap,
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
          onTap: widget.onDeleteAccountTap,
        ),
      ],
    );
  }
}
