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
import '../../bloc/summary_stats_bloc/summary_stats_bloc.dart';
import '../widgets/dashboard_header_widget.dart';
import '../widgets/overview_card_widget.dart';

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
    final topPadding = MediaQuery.of(context).padding.top;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
        BlocProvider(
          create: (_) =>
              getIt<SummaryStatsBloc>()..add(FetchSummaryStatsEvent()),
        ),
      ],
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            backgroundColor: AppColor.white,
            body: Stack(
              children: [
                // ── Top Orange Curved Background ─────────────────────
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topPadding + 195.h,
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
                  ),
                ),

                // ── Scrollable Content with Safe Scrolling ───────────
                Positioned.fill(
                  child: RefreshIndicator(
                    color: AppColor.primary,
                    onRefresh: () async {
                      blocContext
                          .read<SummaryStatsBloc>()
                          .add(FetchSummaryStatsEvent());
                      await _loadUserSession();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: topPadding + 16.h,
                        left: 18.w,
                        right: 18.w,
                        bottom: 100.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vendor Header
                          DashboardHeaderWidget(
                            greeting: 'Hello,',
                            vendorName: _entityName.isNotEmpty
                                ? _entityName
                                : 'Vendor',
                            onProfileTap: () {
                              context.pushNamed(AppRoute.settings.name);
                            },
                          ),
                          20.hS,

                          // Today's Overview Card connected to SummaryStatsBloc
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
