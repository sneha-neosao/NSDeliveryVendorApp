import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import 'order_card_widget.dart';
import 'order_empty_state_widget.dart';

class OrderHistoryViewWidget extends StatefulWidget {
  final List<OrderCardItemData> orders;
  final VoidCallback? onRefresh;
  final ValueChanged<OrderCardItemData>? onOrderTap;

  const OrderHistoryViewWidget({
    super.key,
    required this.orders,
    this.onRefresh,
    this.onOrderTap,
  });

  @override
  State<OrderHistoryViewWidget> createState() => _OrderHistoryViewWidgetState();
}

class _OrderHistoryViewWidgetState extends State<OrderHistoryViewWidget> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All History', 'Delivered', 'Cancelled'];

  List<OrderCardItemData> get _filteredOrders {
    if (_selectedFilterIndex == 0) return widget.orders;
    if (_selectedFilterIndex == 1) {
      return widget.orders
          .where((o) => o.status == OrderStatus.delivered)
          .toList();
    }
    if (_selectedFilterIndex == 2) {
      return widget.orders
          .where((o) => o.status == OrderStatus.cancelled)
          .toList();
    }
    return widget.orders;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return OrderEmptyStateWidget(
        title: 'No Order History',
        description:
            'Past delivered and cancelled orders will be archived and shown here for your records.',
        icon: Icons.history_rounded,
        onRefresh: widget.onRefresh,
      );
    }

    final filtered = _filteredOrders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Chips Row
        SizedBox(
          height: 34.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            itemCount: _filters.length,
            separatorBuilder: (context, index) => 8.wS,
            itemBuilder: (context, index) {
              final isSelected = _selectedFilterIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
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
          ),
        ),
        14.hS,
        // Orders List or Filter Empty State
        if (filtered.isEmpty)
          OrderEmptyStateWidget(
            title: 'No Orders in this category',
            description:
                'There are no history records matching "${_filters[_selectedFilterIndex]}".',
            icon: Icons.filter_alt_off_rounded,
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                return OrderCardWidget(
                  order: item,
                  onTap: () => widget.onOrderTap?.call(item),
                );
              },
            ),
          ),
      ],
    );
  }
}
