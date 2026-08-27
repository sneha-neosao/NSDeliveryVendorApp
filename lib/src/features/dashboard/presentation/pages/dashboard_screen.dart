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
import '../../bloc/performance_metrics_bloc/performance_metrics_bloc.dart';
import '../../bloc/summary_stats_bloc/summary_stats_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final session = await SessionManager.getUserSession();
    final name = session?.data?.restaurant?.entityName;
    if (name != null && name.isNotEmpty && mounted) {
      setState(() {
        _entityName = name;
      });
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
      ],
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            backgroundColor: AppColor.white,
            body: Column(
              children: [
                // ── Fixed Top Header (Keeps Name & Profile Icon Fixed) ──
                DashboardHeaderWidget(
                  greeting: 'Hello,',
                  vendorName:
                      _entityName.isNotEmpty ? _entityName : 'Vendor',
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
                          .read<SummaryStatsBloc>()
                          .add(FetchSummaryStatsEvent());
                      blocContext
                          .read<PerformanceMetricsBloc>()
                          .add(FetchPerformanceMetricsEvent());
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
          );
        },
      ),
    );
  }
}
