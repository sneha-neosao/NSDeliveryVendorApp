import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/items_model/items_list_response.dart';
import 'menu_item_card_widget.dart';
import 'menu_shimmer_widget.dart';

class MenuItemsListViewWidget extends StatefulWidget {
  final List<RestaurantItem> items;
  final Pagination? pagination;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onLoadMore;
  final ValueChanged<RestaurantItem>? onItemTap;

  const MenuItemsListViewWidget({
    super.key,
    required this.items,
    this.pagination,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.onRefresh,
    this.onLoadMore,
    this.onItemTap,
  });

  @override
  State<MenuItemsListViewWidget> createState() =>
      _MenuItemsListViewWidgetState();
}

class _MenuItemsListViewWidgetState extends State<MenuItemsListViewWidget> {
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
    if (_isBottom && !widget.isLoadingMore && !widget.hasReachedMax) {
      widget.onLoadMore?.call();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.items.length + (widget.isLoadingMore ? 1 : 0);

    return RefreshIndicator(
      color: AppColor.primary,
      backgroundColor: AppColor.pureWhite,
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          top: 6.h,
          bottom: 16.h,
        ),
        itemCount: totalCount,
        separatorBuilder: (context, index) => 12.hS,
        itemBuilder: (context, index) {
          // Bottom 1-card shimmer while loading more items
          if (index == widget.items.length) {
            return const MenuShimmerWidget(
              itemCount: 1,
              padding: EdgeInsets.zero,
            );
          }

          final item = widget.items[index];
          return MenuItemCardWidget(
            item: item,
            onTap: () => widget.onItemTap?.call(item),
          );
        },
      ),
    );
  }
}
