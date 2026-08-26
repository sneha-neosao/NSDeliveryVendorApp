import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'order_card_widget.dart';
import 'order_empty_state_widget.dart';

class OngoingOrdersViewWidget extends StatefulWidget {
  final List<OrderCardItemData> orders;
  final VoidCallback? onRefresh;
  final ValueChanged<OrderCardItemData>? onOrderTap;
  final ValueChanged<OrderCardItemData>? onPrimaryActionTap;

  const OngoingOrdersViewWidget({
    super.key,
    required this.orders,
    this.onRefresh,
    this.onOrderTap,
    this.onPrimaryActionTap,
  });

  @override
  State<OngoingOrdersViewWidget> createState() =>
      _OngoingOrdersViewWidgetState();
}

class _OngoingOrdersViewWidgetState extends State<OngoingOrdersViewWidget> {
  // int _selectedFilterIndex = 0;
  // final List<String> _filters = ['All', 'New', 'Preparing', 'Ready'];

  // List<OrderCardItemData> get _filteredOrders {
  //   if (_selectedFilterIndex == 0) return widget.orders;
  //   if (_selectedFilterIndex == 1) {
  //     return widget.orders
  //         .where((o) => o.status == OrderStatus.newOrder)
  //         .toList();
  //   }
  //   if (_selectedFilterIndex == 2) {
  //     return widget.orders
  //         .where((o) => o.status == OrderStatus.preparing)
  //         .toList();
  //   }
  //   if (_selectedFilterIndex == 3) {
  //     return widget.orders
  //         .where((o) => o.status == OrderStatus.ready)
  //         .toList();
  //   }
  //   return widget.orders;
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return OrderEmptyStateWidget(
        title: 'No Ongoing Orders',
        description:
            'You do not have any active or incoming orders right now. New customer orders will appear here automatically.',
        icon: Icons.access_time_rounded,
        onRefresh: widget.onRefresh,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // ── Filter Chips Row (Commented Out) ────────────────────
        // SizedBox(
        //   height: 34.h,
        //   child: ListView.separated(
        //     scrollDirection: Axis.horizontal,
        //     padding: EdgeInsets.symmetric(horizontal: 18.w),
        //     itemCount: _filters.length,
        //     separatorBuilder: (context, index) => 8.wS,
        //     itemBuilder: (context, index) {
        //       final isSelected = _selectedFilterIndex == index;
        //       return GestureDetector(
        //         onTap: () {
        //           setState(() {
        //             _selectedFilterIndex = index;
        //           });
        //         },
        //         behavior: HitTestBehavior.opaque,
        //         child: AnimatedContainer(
        //           duration: const Duration(milliseconds: 200),
        //           padding: EdgeInsets.symmetric(
        //             horizontal: 14.w,
        //             vertical: 6.h,
        //           ),
        //           decoration: BoxDecoration(
        //             color: isSelected ? AppColor.primary : AppColor.pureWhite,
        //             borderRadius: BorderRadius.circular(18.r),
        //             border: Border.all(
        //               color: isSelected
        //                   ? AppColor.primary
        //                   : AppColor.border.withValues(alpha: 0.7),
        //               width: 1.r,
        //             ),
        //           ),
        //           child: Center(
        //             child: Text(
        //               _filters[index],
        //               style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //                     color: isSelected
        //                         ? AppColor.pureWhite
        //                         : AppColor.textSecondary,
        //                     fontWeight:
        //                         isSelected ? FontWeight.w600 : FontWeight.w500,
        //                     fontSize: 12.sp,
        //                   ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // 14.hS,

        // ── Orders List ─────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: widget.orders.length,
            itemBuilder: (context, index) {
              final item = widget.orders[index];
              return OrderCardWidget(
                order: item,
                onTap: () => widget.onOrderTap?.call(item),
                onPrimaryActionTap: () =>
                    widget.onPrimaryActionTap?.call(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
