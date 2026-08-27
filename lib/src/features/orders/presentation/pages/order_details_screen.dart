import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/order_details_bloc/order_details_bloc.dart';
import '../widgets/order_details_bill_summary_card_widget.dart';
import '../widgets/order_details_bottom_action_widget.dart';
import '../widgets/order_details_customer_card_widget.dart';
import '../widgets/order_details_delivery_boy_card_widget.dart';
import '../widgets/order_details_header_widget.dart';
import '../widgets/order_details_items_card_widget.dart';
import '../widgets/order_details_shimmer_widget.dart';
import '../widgets/order_details_status_card_widget.dart';
import '../widgets/order_details_status_timeline_widget.dart';
import '../widgets/order_empty_state_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String uuId;

  const OrderDetailsScreen({
    super.key,
    required this.uuId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
        BlocProvider(
          create: (_) => getIt<OrderDetailsBloc>()
            ..add(GetOrderDetailsEvent(widget.uuId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // ── Top Curved Gradient Header ────────────────────────
            BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
              builder: (context, state) {
                String subtitle = '';
                if (state is OrderDetailsSuccessState &&
                    state.data.data?.id != null) {
                  subtitle = 'ORD_${state.data.data!.id}';
                }

                return OrderDetailsHeaderWidget(
                  title: 'Order Details',
                  subtitle: subtitle,
                );
              },
            ),

            // ── Body Content with Shimmer & Error Handling ────────
            Expanded(
              child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
                builder: (context, state) {
                  // ── Initial / Loading ────────────────────────────
                  if (state is OrderDetailsInitialState ||
                      state is OrderDetailsLoadingState) {
                    return const OrderDetailsShimmerWidget();
                  }

                  // ── Failure ──────────────────────────────────────
                  if (state is OrderDetailsFailureState) {
                    return OrderEmptyStateWidget(
                      title: 'Failed to load details',
                      description: state.message,
                      icon: Icons.error_outline_rounded,
                      onRefresh: () {
                        context
                            .read<OrderDetailsBloc>()
                            .add(GetOrderDetailsEvent(widget.uuId));
                      },
                    );
                  }

                  // ── Success ──────────────────────────────────────
                  if (state is OrderDetailsSuccessState) {
                    final order = state.data.data;
                    if (order == null) {
                      return OrderEmptyStateWidget(
                        title: 'Order Not Found',
                        description:
                            'The requested order details could not be found.',
                        icon: Icons.search_off_rounded,
                        onRefresh: () {
                          context
                              .read<OrderDetailsBloc>()
                              .add(GetOrderDetailsEvent(widget.uuId));
                        },
                      );
                    }

                    return Column(
                      children: [
                        // Scrollable Content
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColor.primary,
                            backgroundColor: AppColor.pureWhite,
                            onRefresh: () async {
                              context
                                  .read<OrderDetailsBloc>()
                                  .add(GetOrderDetailsEvent(widget.uuId));
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 14.h,
                              ),
                              child: Column(
                                children: [
                                  // Status Banner Card
                                  OrderDetailsStatusCardWidget(order: order),
                                  14.hS,

                                  // Customer & Delivery Address Card
                                  OrderDetailsCustomerCardWidget(order: order),
                                  14.hS,

                                  // Ordered Items List Card
                                  OrderDetailsItemsCardWidget(
                                    items: order.items ?? [],
                                    totalItems: order.totalItems ??
                                        order.items?.length ??
                                        0,
                                  ),
                                  14.hS,

                                  // Assigned Delivery Boy Card (if available)
                                  if (order.assignedDeliveryBoy != null) ...[
                                    OrderDetailsDeliveryBoyCardWidget(
                                      deliveryBoy: order.assignedDeliveryBoy,
                                    ),
                                    14.hS,
                                  ],

                                  // Bill Summary Card
                                  OrderDetailsBillSummaryCardWidget(
                                      order: order),
                                  14.hS,

                                  // Status Logs Timeline (if available)
                                  if (order.statusLogs != null &&
                                      order.statusLogs!.isNotEmpty) ...[
                                    OrderDetailsStatusTimelineWidget(
                                      logs: order.statusLogs!,
                                    ),
                                    14.hS,
                                  ],

                                  // Bottom Spacing
                                  16.hS,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Sticky Bottom Action Bar
                        OrderDetailsBottomActionWidget(
                          orderStatus: order.orderStatus,
                          onAcceptTap: () {
                            // Hook for accept & prepare API event
                          },
                          onReadyTap: () {
                            // Hook for ready for pickup API event
                          },
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
