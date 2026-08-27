import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/ongoing_orders_view_widget.dart';
import '../widgets/order_card_widget.dart';
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

  // Sample ongoing orders (mock — to be replaced with API)
  final List<OrderCardItemData> _ongoingOrders = const [
    OrderCardItemData(
      orderId: '#NSD-9481',
      customerName: 'Rahul Sharma',
      itemsSummary: '2x Paneer Butter Masala, 4x Butter Roti, 1x Jeera Rice',
      itemCount: 7,
      totalAmount: '₹540.00',
      time: 'Just now',
      status: OrderStatus.newOrder,
    ),
    OrderCardItemData(
      orderId: '#NSD-9478',
      customerName: 'Priya Deshmukh',
      itemsSummary: '1x Veg Schezwan Noodles, 1x Manchurian Dry',
      itemCount: 2,
      totalAmount: '₹320.00',
      time: '12 mins ago',
      status: OrderStatus.preparing,
    ),
    OrderCardItemData(
      orderId: '#NSD-9472',
      customerName: 'Amit Verma',
      itemsSummary: '1x Margherita Pizza (Medium), 1x Garlic Breadsticks',
      itemCount: 2,
      totalAmount: '₹460.00',
      time: '25 mins ago',
      status: OrderStatus.ready,
    ),
  ];

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
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // Top Compact Orange Curved Header
            const OrdersHeaderWidget(title: 'Orders'),
            14.hS,

            // Tab Switcher
            OrdersTabSelectorWidget(
              selectedIndex: _selectedTabIndex,
              ongoingCount: _ongoingOrders.length,
              historyCount: 0,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            14.hS,

            // Tab Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _selectedTabIndex == 0
                    ? SingleChildScrollView(
                        key: const ValueKey('ongoing_orders_view'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 100.h),
                        child: OngoingOrdersViewWidget(
                          orders: _ongoingOrders,
                        ),
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
