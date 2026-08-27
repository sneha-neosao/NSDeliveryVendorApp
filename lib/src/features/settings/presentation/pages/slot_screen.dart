import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/slots_list_bloc/slots_list_bloc.dart';
import '../widgets/slot_card_widget.dart';
import '../widgets/slot_empty_state_widget.dart';
import '../widgets/slot_header_widget.dart';
import '../widgets/slot_shimmer_widget.dart';

class SlotScreen extends StatefulWidget {
  const SlotScreen({super.key});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Trigger load more pagination
      // Note: we can dispatch using blocContext inside build or retrieve it from current tree
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
        BlocProvider(
          create: (_) => getIt<SlotsListBloc>()
            ..add(const GetSlotsListEvent(page: 1, limit: 10)),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // ── Top Header ──────────────────────────────────────────
            const SlotHeaderWidget(
              title: 'Time Slots',
              subtitle: 'Manage your operating hours',
            ),

            // ── Body Content with Pagination & Shimmer ──────────────
            Expanded(
              child: Builder(
                builder: (blocContext) {
                  return BlocBuilder<SlotsListBloc, SlotsListState>(
                    builder: (context, state) {
                      // ── Initial / Loading ───────────────────────────
                      if (state is SlotsListInitialState ||
                          state is SlotsListLoadingState) {
                        return const SlotShimmerWidget();
                      }

                      // ── Failure ─────────────────────────────────────
                      if (state is SlotsListFailureState) {
                        return SlotEmptyStateWidget(
                          title: 'Failed to load time slots',
                          description: state.message,
                          icon: Icons.error_outline_rounded,
                          onRefresh: () {
                            blocContext.read<SlotsListBloc>().add(
                                  const GetSlotsListEvent(page: 1, limit: 10),
                                );
                          },
                        );
                      }

                      // ── Success ─────────────────────────────────────
                      if (state is SlotsListSuccessState) {
                        final items = state.items;

                        if (items.isEmpty) {
                          return SlotEmptyStateWidget(
                            title: 'No Time Slots Found',
                            description:
                                'No operating time slots are currently configured for your store.',
                            onRefresh: () {
                              blocContext.read<SlotsListBloc>().add(
                                    const GetSlotsListEvent(page: 1, limit: 10),
                                  );
                            },
                          );
                        }

                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification ||
                                notification.metrics.pixels >=
                                    notification.metrics.maxScrollExtent - 200) {
                              if (!state.hasReachedMax && !state.isLoadingMore) {
                                blocContext
                                    .read<SlotsListBloc>()
                                    .add(const LoadMoreSlotsListEvent());
                              }
                            }
                            return false;
                          },
                          child: RefreshIndicator(
                            color: AppColor.primary,
                            backgroundColor: AppColor.pureWhite,
                            onRefresh: () async {
                              blocContext.read<SlotsListBloc>().add(
                                    const GetSlotsListEvent(page: 1, limit: 10),
                                  );
                            },
                            child: ListView.separated(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 14.h,
                              ),
                              itemCount: items.length +
                                  (state.isLoadingMore ? 1 : 0),
                              separatorBuilder: (_, _) => 12.hS,
                              itemBuilder: (context, index) {
                                if (index < items.length) {
                                  return SlotCardWidget(slot: items[index]);
                                }

                                // Bottom pagination loader
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24.r,
                                      height: 24.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
