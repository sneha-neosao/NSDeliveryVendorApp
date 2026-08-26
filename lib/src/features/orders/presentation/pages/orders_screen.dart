import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
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

  // Sample ongoing orders
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

  // Sample order history
  final List<OrderCardItemData> _orderHistory = const [
    OrderCardItemData(
      orderId: '#NSD-9465',
      customerName: 'Sneha Patel',
      itemsSummary: '1x Dal Tadka, 2x Naan, 1x Steamed Rice',
      itemCount: 4,
      totalAmount: '₹290.00',
      time: 'Yesterday, 8:45 PM',
      status: OrderStatus.delivered,
    ),
    OrderCardItemData(
      orderId: '#NSD-9459',
      customerName: 'Vikram Joshi',
      itemsSummary: '2x Double Cheese Burger, 1x Large Peri Peri Fries',
      itemCount: 3,
      totalAmount: '₹380.00',
      time: 'Yesterday, 7:15 PM',
      status: OrderStatus.delivered,
    ),
    OrderCardItemData(
      orderId: '#NSD-9450',
      customerName: 'Rohan Gupta',
      itemsSummary: '1x Masala Dosa, 1x Idli Sambhar (2 pcs)',
      itemCount: 2,
      totalAmount: '₹180.00',
      time: '24 Aug, 1:20 PM',
      status: OrderStatus.cancelled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // Top Compact Orange Curved Header
            const OrdersHeaderWidget(
              title: 'Orders',
            ),
            14.hS,
            // Innovative Modern Tab Switcher
            OrdersTabSelectorWidget(
              selectedIndex: _selectedTabIndex,
              ongoingCount: _ongoingOrders.length,
              historyCount: _orderHistory.length,
              onTabChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
            14.hS,
            // Content View (Ongoing vs History) with safe bottom padding for floating bar
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: 100.h, // Bottom clearance for floating bottom bar
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _selectedTabIndex == 0
                      ? OngoingOrdersViewWidget(
                          key: const ValueKey('ongoing_orders_view'),
                          orders: _ongoingOrders,
                        )
                      : OrderHistoryViewWidget(
                          key: const ValueKey('order_history_view'),
                          orders: _orderHistory,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
