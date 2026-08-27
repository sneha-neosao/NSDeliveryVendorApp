import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/ongoing_orders_view_widget.dart';
import '../widgets/order_history_view_widget.dart';
import '../widgets/orders_header_widget.dart';
import '../widgets/orders_tab_selector_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
        BlocProvider(
          create: (_) => getIt<OrderHistoryBloc>()
            ..add(const GetOrderHistoryEvent(page: 1, limit: 10)),
        ),
        BlocProvider(
          create: (_) => getIt<OrdersListBloc>()
            ..add(const GetOrdersListEvent(page: 1, limit: 10)),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // Top Compact Orange Curved Header
            const OrdersHeaderWidget(title: 'Orders'),
            14.hS,

            // Tab Switcher
            BlocBuilder<OrdersListBloc, OrdersListState>(
              builder: (context, ongoingState) {
                final ongoingCount =
                    ongoingState is OrdersListSuccessState
                        ? ongoingState.items.length
                        : 0;

                return OrdersTabSelectorWidget(
                  selectedIndex: _selectedTabIndex,
                  ongoingCount: ongoingCount,
                  historyCount: 0,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                );
              },
            ),
            14.hS,

            // Tab Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _selectedTabIndex == 0
                    ? const OngoingOrdersViewWidget(
                        key: ValueKey('ongoing_orders_view'),
                      )
                    : const OrderHistoryViewWidget(
                        key: ValueKey('order_history_view'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
