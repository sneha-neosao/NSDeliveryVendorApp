import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/auth_model/app_version_response.dart';
import '../../../../routes/app_route_path.dart';
import '../../../login/bloc/update_firebase_token_bloc/update_firebase_token_bloc.dart';
import '../../../settings/bloc/profile_bloc/profile_bloc.dart';
import '../../../splash/bloc/app_version_bloc/app_version_bloc.dart';
import '../../bloc/performance_metrics_bloc/performance_metrics_bloc.dart';
import '../../bloc/summary_stats_bloc/summary_stats_bloc.dart';
import '../widgets/app_update_dialog.dart';
import '../widgets/dashboard_header_widget.dart';
import '../widgets/order_performance_widget.dart';
import '../widgets/overview_card_widget.dart';
import '../widgets/top_products_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _entityName = '';
  String? _userImage;

  @override
  void initState() {
    super.initState();
    _loadUserSession();
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

  Future<void> _loadUserSession() async {
    final session = await SessionManager.getUserSession();
    final restaurant = session?.data?.restaurant;
    if (restaurant != null && mounted) {
      setState(() {
        final name = _cleanString(restaurant.entityName);
        final img = _cleanString(restaurant.entityImage);
        if (name != null) _entityName = name;
        if (img != null) _userImage = img;
      });
    }
  }

  Future<void> _updateFirebaseToken(BuildContext blocContext) async {
    try {
      final token = await NoficationService.getToken();
      if (token != null && token.isNotEmpty && mounted) {
        blocContext
            .read<UpdateFirebaseTokenBloc>()
            .add(UpdateFirebaseTokenSubmitEvent(token));
      }
    } catch (_) {
      // Silent execution
    }
  }

  Future<void> _handleAppVersionCheck(AppVersionResponse response) async {
    try {
      final data = response.data;
      if (data == null) return;

      final PlatformAppVersion? platformData;
      if (Platform.isIOS) {
        platformData = data.ios;
      } else {
        platformData = data.android;
      }

      if (platformData == null) return;

      final serverVersion = platformData.version?.trim() ?? '';
      if (serverVersion.isEmpty) return;

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version.trim();

      if (_isVersionOutdated(currentVersion, serverVersion)) {
        if (!mounted) return;
        AppUpdateDialog.show(
          context,
          newVersion: serverVersion,
          updateMessage: platformData.updateMessage ?? '',
          storeLink: platformData.storeLink ?? '',
          isForceUpdate: platformData.forceUpdate ?? false,
        );
      }
    } catch (e) {
      logger.e('Error during app version check: $e');
    }
  }

  bool _isVersionOutdated(String currentVersion, String serverVersion) {
    try {
      final currentParts = currentVersion
          .split('.')
          .map((e) => int.tryParse(e.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
          .toList();
      final serverParts = serverVersion
          .split('.')
          .map((e) => int.tryParse(e.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
          .toList();

      final maxLength = currentParts.length > serverParts.length
          ? currentParts.length
          : serverParts.length;

      for (int i = 0; i < maxLength; i++) {
        final current = i < currentParts.length ? currentParts[i] : 0;
        final server = i < serverParts.length ? serverParts[i] : 0;

        if (server > current) {
          return true;
        } else if (server < current) {
          return false;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
        BlocProvider(
          create: (_) =>
              getIt<SummaryStatsBloc>()..add(FetchSummaryStatsEvent()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<PerformanceMetricsBloc>()..add(FetchPerformanceMetricsEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<UpdateFirebaseTokenBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<ProfileBloc>()..add(FetchProfileEvent()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<AppVersionBloc>()..add(FetchAppVersionEvent()),
        ),
      ],
      child: Builder(
        builder: (blocContext) {
          // Trigger silent Firebase token update on initial render
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateFirebaseToken(blocContext);
          });

          return MultiBlocListener(
            listeners: [
              BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileSuccessState) {
                    final profile = state.data.data;
                    if (profile != null && mounted) {
                      setState(() {
                        final entity = _cleanString(profile.entityName);
                        final img = _cleanString(profile.entityImage);
                        if (entity != null) _entityName = entity;
                        if (img != null) _userImage = img;
                      });
                    }
                  }
                },
              ),
              BlocListener<AppVersionBloc, AppVersionState>(
                listener: (context, state) {
                  if (state is AppVersionSuccessState) {
                    _handleAppVersionCheck(state.data);
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: AppColor.white,
              body: Column(
                children: [
                  // ── Fixed Top Header (Keeps Name & Profile Icon Fixed) ──
                  DashboardHeaderWidget(
                    greeting: 'Hello,',
                    vendorName:
                        _entityName.isNotEmpty ? _entityName : 'Vendor',
                    userImage: _userImage,
                    onProfileTap: () {
                      context.pushNamed(AppRoute.settings.name);
                    },
                  ),

                  // ── Scrollable Body Below Fixed Orange Header ──────────
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColor.primary,
                      onRefresh: () async {
                        blocContext
                            .read<ProfileBloc>()
                            .add(FetchProfileEvent());
                        blocContext
                            .read<SummaryStatsBloc>()
                            .add(FetchSummaryStatsEvent());
                        blocContext
                            .read<PerformanceMetricsBloc>()
                            .add(FetchPerformanceMetricsEvent());
                        blocContext
                            .read<AppVersionBloc>()
                            .add(FetchAppVersionEvent());
                        _updateFirebaseToken(blocContext);
                        await _loadUserSession();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 16.h,
                          left: 18.w,
                          right: 18.w,
                          bottom: 16.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Store Overview Card (Summary Stats)
                            BlocBuilder<SummaryStatsBloc, SummaryStatsState>(
                              builder: (context, state) {
                                final isLoading =
                                    state is SummaryStatsLoadingState;
                                final isFailure =
                                    state is SummaryStatsFailureState;
                                final data = state is SummaryStatsSuccessState
                                    ? state.data.data
                                    : null;

                                return OverviewCardWidget(
                                  isLoading: isLoading,
                                  dateText: _getFormattedDate(),
                                  liveActiveOrders:
                                      data?.liveActiveOrders ?? 0,
                                  totalMenuItems: data?.totalMenuItems ?? 0,
                                  partnerRating: data?.partnerRating ?? 0,
                                  errorMessage: isFailure
                                      ? (state as SummaryStatsFailureState).message
                                      : null,
                                  onRetryTap: () {
                                    blocContext
                                        .read<SummaryStatsBloc>()
                                        .add(FetchSummaryStatsEvent());
                                  },
                                  onLiveOrdersTap: () {
                                    context.go(AppRoute.orders.path);
                                  },
                                  onMenuItemsTap: () {
                                    context.go(AppRoute.menu.path);
                                  },
                                );
                              },
                            ),
                            18.hS,

                            // 2. Order Performance & Top Products
                            BlocBuilder<PerformanceMetricsBloc,
                                PerformanceMetricsState>(
                              builder: (context, state) {
                                final isLoading =
                                    state is PerformanceMetricsLoadingState;
                                final data =
                                    state is PerformanceMetricsSuccessState
                                        ? state.data.data
                                        : null;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Order Performance Card
                                    OrderPerformanceWidget(
                                      performance: data?.orderPerformance,
                                      isLoading: isLoading,
                                    ),
                                    18.hS,

                                    // Top Selling Dishes Card
                                    TopProductsWidget(
                                      topProducts: data?.topProducts ?? [],
                                      isLoading: isLoading,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
