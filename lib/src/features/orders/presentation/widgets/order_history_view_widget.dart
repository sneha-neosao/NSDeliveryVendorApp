import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/order_history_model/order_history_response.dart';
import '../../bloc/order_history_bloc/order_history_bloc.dart';
import 'order_empty_state_widget.dart';
import 'order_history_card_widget.dart';
import 'order_history_shimmer_widget.dart';

class OrderHistoryViewWidget extends StatefulWidget {
  const OrderHistoryViewWidget({super.key});

  @override
  State<OrderHistoryViewWidget> createState() => _OrderHistoryViewWidgetState();
}

class _OrderHistoryViewWidgetState extends State<OrderHistoryViewWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= maxScroll - 200) {
      final state = context.read<OrderHistoryBloc>().state;
      if (state is OrderHistorySuccessState &&
          !state.isLoadingMore &&
          !state.hasReachedMax) {
        context.read<OrderHistoryBloc>().add(LoadMoreOrderHistoryEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
      builder: (context, state) {
        // ── Initial / Loading ──────────────────────────────────
        if (state is OrderHistoryInitialState ||
            state is OrderHistoryLoadingState) {
          return const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: OrderHistoryShimmerWidget(),
          );
        }

        // ── Failure ────────────────────────────────────────────
        if (state is OrderHistoryFailureState) {
          return OrderEmptyStateWidget(
            title: 'Failed to load history',
            description: state.message,
            icon: Icons.error_outline_rounded,
            onRefresh: () {
              context
                  .read<OrderHistoryBloc>()
                  .add(const GetOrderHistoryEvent(page: 1, limit: 10));
            },
          );
        }

        // ── Success ────────────────────────────────────────────
        if (state is OrderHistorySuccessState) {
          final items = state.items;

          if (items.isEmpty) {
            return OrderEmptyStateWidget(
              title: 'No Order History',
              description:
                  'Past delivered and cancelled orders will be archived and shown here for your records.',
              icon: Icons.history_rounded,
              onRefresh: () {
                context
                    .read<OrderHistoryBloc>()
                    .add(const GetOrderHistoryEvent(page: 1, limit: 10));
              },
            );
          }

          final totalCount = items.length + (state.isLoadingMore ? 1 : 0);

          return RefreshIndicator(
            color: AppColor.primary,
            backgroundColor: AppColor.pureWhite,
            onRefresh: () async {
              context
                  .read<OrderHistoryBloc>()
                  .add(const GetOrderHistoryEvent(page: 1, limit: 10));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Filter Chips Row (All History / Delivered / Cancelled) ──
                SizedBox(
                  height: 34.h,
                  child: _FilterChipsRow(items: items),
                ),
                14.hS,
                // ── History List with pagination ──────────────────
                Expanded(
                  child: _HistoryListView(
                    items: items,
                    totalCount: totalCount,
                    isLoadingMore: state.isLoadingMore,
                    scrollController: _scrollController,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _FilterChipsRow extends StatefulWidget {
  final List<OrderHistoryItem> items;

  const _FilterChipsRow({required this.items});

  @override
  State<_FilterChipsRow> createState() => _FilterChipsRowState();
}

class _FilterChipsRowState extends State<_FilterChipsRow> {
  int _selectedIndex = 0;
  final List<String> _filters = ['All History', 'Delivered', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      itemCount: _filters.length,
      separatorBuilder: (_, _) => 8.wS,
      itemBuilder: (context, index) {
        final isSelected = _selectedIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primary : AppColor.pureWhite,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isSelected
                    ? AppColor.primary
                    : AppColor.border.withValues(alpha: 0.7),
                width: 1.r,
              ),
            ),
            child: Center(
              child: Text(
                _filters[index],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppColor.pureWhite
                          : AppColor.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 12.sp,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HistoryListView extends StatelessWidget {
  final List<OrderHistoryItem> items;
  final int totalCount;
  final bool isLoadingMore;
  final ScrollController scrollController;

  const _HistoryListView({
    required this.items,
    required this.totalCount,
    required this.isLoadingMore,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 4.h,
        bottom: 100.h,
      ),
      itemCount: totalCount,
      separatorBuilder: (_, _) => 12.hS,
      itemBuilder: (context, index) {
        // Bottom 1-card shimmer while paginating
        if (index == items.length) {
          return const OrderHistoryShimmerWidget(
            itemCount: 1,
            padding: EdgeInsets.zero,
          );
        }
        return OrderHistoryCardWidget(order: items[index]);
      },
    );
  }
}
