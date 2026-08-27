import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/slots_list_bloc/slots_list_bloc.dart';
import '../widgets/add_slot_bottom_sheet_widget.dart';
import '../widgets/delete_slot_confirmation_dialog.dart';
import '../widgets/edit_slot_bottom_sheet_widget.dart';
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
        BlocProvider(create: (_) => getIt<SlotCreateBloc>()),
      ],
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            backgroundColor: AppColor.white,
            // ── Floating Action Button at Bottom-Right Corner ────────
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: _buildAddSlotFab(blocContext),
            body: Column(
              children: [
                // ── Top Header ──────────────────────────────────────────
                const SlotHeaderWidget(
                  title: 'Time Slots',
                  subtitle: 'Manage your operating hours',
                ),

                // ── Body Content with Pagination & Shimmer ──────────────
                Expanded(
                  child: BlocBuilder<SlotsListBloc, SlotsListState>(
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
                              padding: EdgeInsets.only(
                                left: 18.w,
                                right: 18.w,
                                top: 14.h,
                                bottom: 80.h,
                              ),
                              itemCount: items.length +
                                  (state.isLoadingMore ? 1 : 0),
                              separatorBuilder: (_, _) => 12.hS,
                              itemBuilder: (context, index) {
                                if (index < items.length) {
                                  final slotItem = items[index];
                                  return SlotCardWidget(
                                    slot: slotItem,
                                    onEditTap: () {
                                      EditSlotBottomSheetWidget.show(
                                        blocContext,
                                        slot: slotItem,
                                        onUpdateSlot: (
                                          slot,
                                          day,
                                          startTime,
                                          endTime,
                                          isActive,
                                        ) {
                                          // Hook for slot update API
                                        },
                                      );
                                    },
                                    onDeleteTap: () {
                                      DeleteSlotConfirmationDialog.show(
                                        blocContext,
                                        slot: slotItem,
                                        onConfirmDelete: () {
                                          // Hook for slot deletion API
                                        },
                                      );
                                    },
                                  );
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddSlotFab(BuildContext context) {
    return Container(
      width: 56.r,
      height: 56.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primary, AppColor.darkOrange],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            AddSlotBottomSheetWidget.show(
              context,
              onSlotCreated: () {
                context
                    .read<SlotsListBloc>()
                    .add(const GetSlotsListEvent(page: 1, limit: 10));
              },
            );
          },
          child: Center(
            child: Icon(
              Icons.add_rounded,
              color: AppColor.pureWhite,
              size: 30.r,
            ),
          ),
        ),
      ),
    );
  }
}
