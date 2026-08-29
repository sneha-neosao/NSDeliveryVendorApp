import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../../dashboard/bloc/serviceability_bloc/serviceability_bloc.dart';
import '../../../login/bloc/auth_login_bloc/auth_login_bloc.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../widgets/delete_account_confirmation_dialog.dart';
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
  String _storeName = 'Vendor';
  String _email = '';
  String _phone = '';
  bool _isServiceOn = true;

  @override
  void initState() {
    super.initState();
    _loadVendorSession();
  }

  String? _cleanString(String? val) {
    if (val == null) return null;
    final trimmed = val.trim();
    if (trimmed.isEmpty ||
        trimmed.toLowerCase() == 'string' ||
        trimmed.toLowerCase() == 'null') {
      return null;
    }
    return trimmed;
  }

  Future<void> _loadVendorSession() async {
    final session = await SessionManager.getUserSession();
    final restaurant = session?.data?.restaurant;

    if (restaurant != null && mounted) {
      setState(() {
        final entity = _cleanString(restaurant.entityName);
        final mail = _cleanString(restaurant.email);
        if (entity != null) _storeName = entity;
        if (mail != null) _email = mail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthLoginBloc>()),
        BlocProvider(create: (_) => getIt<ServiceabilityBloc>()),
        BlocProvider(create: (_) => getIt<DeleteAccountBloc>()),
        BlocProvider(
          create: (_) => getIt<ProfileBloc>()..add(FetchProfileEvent()),
        ),
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          // Profile Details Listener: Update profile details & auto_is_serviceable toggle flag
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccessState) {
                final profile = state.data.data;
                if (profile != null && mounted) {
                  setState(() {
                    final entity = _cleanString(profile.entityName);
                    final mail = _cleanString(profile.email);
                    final contact = _cleanString(profile.entityContact);

                    if (entity != null) _storeName = entity;
                    if (mail != null) _email = mail;
                    if (contact != null) _phone = contact;

                    // Serviceability toggle based on auto_is_serviceable flag
                    if (profile.autoIsServiceable != null) {
                      _isServiceOn = profile.autoIsServiceable!;
                    }
                  });
                }
              }
            },
          ),
          // Serviceability Update Listener
          BlocListener<ServiceabilityBloc, ServiceabilityState>(
            listener: (context, state) {
              if (state is ServiceabilityUpdateSuccessState) {
                if (state.data.data?.adminIsServiceable != null) {
                  setState(() {
                    _isServiceOn = state.data.data!.adminIsServiceable!;
                  });
                }
                appSnackBar(
                  context,
                  AppColor.green,
                  state.data.message ?? 'Serviceability updated successfully',
                );
              } else if (state is ServiceabilityUpdateFailureState) {
                appSnackBar(
                  context,
                  AppColor.bright_red,
                  state.message,
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (blocContext) {
            return Scaffold(
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
                                color:
                                    AppColor.pureWhite.withValues(alpha: 0.08),
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
                        bottom: 16.h,
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
                            onEditTap: () async {
                              final result = await blocContext
                                  .push(AppRoute.editProfile.path);
                              if (result == true && blocContext.mounted) {
                                blocContext
                                    .read<ProfileBloc>()
                                    .add(FetchProfileEvent());
                              }
                            },
                          ),
                          18.hS,
                          // Settings Menu List Options
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, profileState) {
                              final isProfileLoading =
                                  profileState is ProfileLoadingState ||
                                      profileState is ProfileInitialState;

                              return BlocBuilder<ServiceabilityBloc,
                                  ServiceabilityState>(
                                builder: (_, serviceState) {
                                  final isUpdatingServiceability =
                                      serviceState
                                          is ServiceabilityUpdateLoadingState;

                                  return SettingsMenuListWidget(
                                    isServiceOn: _isServiceOn,
                                    isProfileLoading: isProfileLoading,
                                    isServiceabilityLoading:
                                        isUpdatingServiceability,
                                    onServiceabilityChanged: (isOn) {
                                      blocContext
                                          .read<ServiceabilityBloc>()
                                          .add(
                                            UpdateServiceabilityEvent(
                                              adminIsServiceable: isOn,
                                            ),
                                          );
                                    },
                                    onChangePasswordTap: () => blocContext
                                        .push(AppRoute.changePassword.path),
                                    onTimeSlotsTap: () => blocContext
                                        .push(AppRoute.slots.path),
                                    onLogoutTap: () =>
                                        LogoutConfirmationDialog.show(
                                            blocContext),
                                    onDeleteAccountTap: () =>
                                        DeleteAccountConfirmationDialog.show(
                                            blocContext),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
