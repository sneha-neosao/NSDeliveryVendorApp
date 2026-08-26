import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/theme/app_color.dart';
import '../../../login/presentation/bloc/auth_login_bloc/auth_login_bloc.dart';
import '../widgets/logout_confirmation_dialog.dart';
import '../widgets/profile_info_card_widget.dart';
import '../widgets/settings_header_widget.dart';
import '../widgets/settings_menu_list_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _storeName = 'Aashu Snacks Corner';
  String _email = 'aashukale15@gmail.com';
  final String _phone = '+91 98765 43210';

  @override
  void initState() {
    super.initState();
    _loadVendorSession();
  }

  Future<void> _loadVendorSession() async {
    final session = await SessionManager.getUserSession();
    final restaurant = session?.data?.restaurant;

    if (restaurant != null && mounted) {
      setState(() {
        if (restaurant.entityName != null &&
            restaurant.entityName!.trim().isNotEmpty) {
          _storeName = restaurant.entityName!;
        }
        if (restaurant.email != null &&
            restaurant.email!.trim().isNotEmpty) {
          _email = restaurant.email!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthLoginBloc>()),
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Stack(
          children: [
            // Top Orange Curved Background Banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topPadding + 160.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColor.primary,
                      AppColor.darkOrange,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28.r),
                    bottomRight: Radius.circular(28.r),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30.r,
                      top: -20.r,
                      child: Container(
                        width: 180.r,
                        height: 180.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.pureWhite.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Safe Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: topPadding + 10.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.of(context).padding.bottom + 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar Header with Back Button and Profile Title
                    const SettingsHeaderWidget(),
                    28.hS,
                    // Floating White Profile Info Card Overlay
                    ProfileInfoCardWidget(
                      storeName: _storeName,
                      email: _email,
                      phoneNumber: _phone,
                      onEditTap: () {},
                    ),
                    18.hS,
                    // Settings Menu List Options
                    Builder(
                      builder: (blocContext) {
                        return SettingsMenuListWidget(
                          onServiceabilityChanged: (isOn) {},
                          onTimeSlotsTap: () {},
                          onLogoutTap: () =>
                              LogoutConfirmationDialog.show(blocContext),
                          onDeleteAccountTap: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
