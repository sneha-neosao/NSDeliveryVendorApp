import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/orders_list_model/orders_list_response.dart';
import '../../../../routes/app_route_path.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../bloc/order_update_status_bloc/order_update_status_bloc.dart';
import '../../bloc/orders_list_bloc/orders_list_bloc.dart';
import 'ongoing_order_card_widget.dart';
import 'ongoing_orders_shimmer_widget.dart';
import 'order_empty_state_widget.dart';

class OngoingOrdersViewWidget extends StatefulWidget {
  const OngoingOrdersViewWidget({super.key});

  @override
  State<OngoingOrdersViewWidget> createState() =>
      _OngoingOrdersViewWidgetState();
}

class _OngoingOrdersViewWidgetState extends State<OngoingOrdersViewWidget> {
  final ScrollController _scrollController = ScrollController();
  String? _updatingOrderUuId;

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
      final state = context.read<OrdersListBloc>().state;
      if (state is OrdersListSuccessState &&
          !state.isLoadingMore &&
          !state.hasReachedMax) {
        context.read<OrdersListBloc>().add(LoadMoreOrdersListEvent());
      }
    }
  }

  void _updateStatus(String uuId, String targetStatus) {
    setState(() {
      _updatingOrderUuId = uuId;
    });
    context.read<OrderUpdateStatusBloc>().add(
          UpdateOrderStatusEvent(
            uuId: uuId,
            orderStatus: targetStatus,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderUpdateStatusBloc, OrderUpdateStatusState>(
      listener: (context, updateState) {
        if (updateState is OrderUpdateStatusSuccessState) {
          final message = updateState.data.message?.isNotEmpty == true
              ? updateState.data.message!
              : 'Order status updated successfully';
          appSnackBar(context, AppColor.green, message);
          setState(() {
            _updatingOrderUuId = null;
          });
          // Refresh the orders list API on success
          context
              .read<OrdersListBloc>()
              .add(const GetOrdersListEvent(page: 1, limit: 10));
        } else if (updateState is OrderUpdateStatusFailureState) {
          appSnackBar(context, AppColor.bright_red, updateState.message);
          setState(() {
            _updatingOrderUuId = null;
          });
        }
      },
      builder: (context, updateState) {
        return BlocBuilder<OrdersListBloc, OrdersListState>(
          builder: (context, state) {
            // ── Initial / Loading ──────────────────────────────────
            if (state is OrdersListInitialState ||
                state is OrdersListLoadingState) {
              return const SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: OngoingOrdersShimmerWidget(),
              );
            }

            // ── Failure ────────────────────────────────────────────
            if (state is OrdersListFailureState) {
              return OrderEmptyStateWidget(
                title: 'Failed to load orders',
                description: state.message,
                icon: Icons.error_outline_rounded,
                onRefresh: () {
                  context
                      .read<OrdersListBloc>()
                      .add(const GetOrdersListEvent(page: 1, limit: 10));
                },
              );
            }

            // ── Success ────────────────────────────────────────────
            if (state is OrdersListSuccessState) {
              final items = state.items;

              if (items.isEmpty) {
                return OrderEmptyStateWidget(
                  title: 'No Ongoing Orders',
                  description:
                      'You do not have any active or incoming orders right now. New customer orders will appear here automatically.',
                  icon: Icons.access_time_rounded,
                  onRefresh: () {
                    context
                        .read<OrdersListBloc>()
                        .add(const GetOrdersListEvent(page: 1, limit: 10));
                  },
                );
              }

              final totalCount = items.length + (state.isLoadingMore ? 1 : 0);

              return RefreshIndicator(
                color: AppColor.primary,
                backgroundColor: AppColor.pureWhite,
                onRefresh: () async {
                  context
                      .read<OrdersListBloc>()
                      .add(const GetOrdersListEvent(page: 1, limit: 10));
                },
                child: _OngoingOrdersListView(
                  items: items,
                  totalCount: totalCount,
                  isLoadingMore: state.isLoadingMore,
                  scrollController: _scrollController,
                  updatingOrderUuId: _updatingOrderUuId,
                  isActionLoading:
                      updateState is OrderUpdateStatusLoadingState,
                  onAcceptTap: (uuId) => _updateStatus(uuId, 'ACCEPTED'),
                  onReadyTap: (uuId) =>
                      _updateStatus(uuId, 'READY_FOR_PICKUP'),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _OngoingOrdersListView extends StatelessWidget {
  final List<OrdersListItem> items;
  final int totalCount;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final String? updatingOrderUuId;
  final bool isActionLoading;
  final ValueChanged<String> onAcceptTap;
  final ValueChanged<String> onReadyTap;

  const _OngoingOrdersListView({
    required this.items,
    required this.totalCount,
    required this.isLoadingMore,
    required this.scrollController,
    this.updatingOrderUuId,
    required this.isActionLoading,
    required this.onAcceptTap,
    required this.onReadyTap,
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
        bottom: 16.h,
      ),
      itemCount: totalCount,
      separatorBuilder: (_, _) => 0.hS,
      itemBuilder: (context, index) {
        // Bottom 1-card shimmer while paginating
        if (index == items.length) {
          return const OngoingOrdersShimmerWidget(
            itemCount: 1,
            padding: EdgeInsets.zero,
          );
        }
        final item = items[index];
        final isItemUpdating =
            isActionLoading && updatingOrderUuId == item.uuId;

        return OngoingOrderCardWidget(
          order: item,
          isActionLoading: isItemUpdating,
          onTap: () {
            if (item.uuId != null && item.uuId!.isNotEmpty) {
              context.push(AppRoute.orderDetails.path, extra: item.uuId);
            }
          },
          onAcceptTap: () {
            if (item.uuId != null && item.uuId!.isNotEmpty) {
              onAcceptTap(item.uuId!);
            }
          },
          onReadyTap: () {
            if (item.uuId != null && item.uuId!.isNotEmpty) {
              onReadyTap(item.uuId!);
            }
          },
        );
      },
    );
  }
}
