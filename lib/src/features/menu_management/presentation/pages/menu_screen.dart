import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../bloc/items_list_bloc/items_list_bloc.dart';
import '../widgets/menu_empty_state_widget.dart';
import '../widgets/menu_header_widget.dart';
import '../widgets/menu_items_list_view_widget.dart';
import '../widgets/menu_search_filter_widget.dart';
import '../widgets/menu_shimmer_widget.dart';

/// Menu Screen displaying restaurant items list with search query, active/inactive filters, shimmer loading, and full state handling.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
        BlocProvider(
          create: (_) => getIt<ItemsListBloc>()
            ..add(const GetItemsListEvent(page: 1, limit: 10)),
        ),
      ],
      child: const Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // Top Compact Orange Curved Title Bar
            MenuHeaderWidget(
              title: 'Menu',
            ),
            // Menu Search Filter & Body Content
            Expanded(
              child: _MenuContentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuContentWidget extends StatefulWidget {
  const _MenuContentWidget();

  @override
  State<_MenuContentWidget> createState() => _MenuContentWidgetState();
}

class _MenuContentWidgetState extends State<_MenuContentWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedStatus; // 'Active', 'Inactive', or null

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchItems(q: query.trim().isNotEmpty ? query.trim() : null);
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    _fetchItems(q: null);
  }

  void _onStatusChanged(String? status) {
    setState(() {
      _selectedStatus = status;
    });
    _fetchItems(status: status);
  }

  void _fetchItems({String? q, String? status}) {
    final queryText = q ??
        (_searchController.text.trim().isNotEmpty
            ? _searchController.text.trim()
            : null);
    final statusFilter = status ?? _selectedStatus;

    context.read<ItemsListBloc>().add(
          GetItemsListEvent(
            page: 1,
            limit: 10,
            q: queryText,
            status: statusFilter,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Search Field (Corners Round 25.r) & Active/Inactive Chips ──
        MenuSearchFilterWidget(
          searchController: _searchController,
          selectedStatus: _selectedStatus,
          onSearchChanged: _onSearchChanged,
          onClearSearch: _onClearSearch,
          onStatusChanged: _onStatusChanged,
        ),

        // ── Items List / Shimmer / Empty State ───────────────────────
        Expanded(
          child: BlocBuilder<ItemsListBloc, ItemsListState>(
            builder: (context, state) {
              if (state is ItemsListLoadingState ||
                  state is ItemsListInitialState) {
                return const SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: MenuShimmerWidget(),
                );
              }

              if (state is ItemsListFailureState) {
                return MenuEmptyStateWidget(
                  title: 'Failed to load menu',
                  description: state.message,
                  onRefresh: () {
                    _fetchItems();
                  },
                );
              }

              if (state is ItemsListSuccessState) {
                final items = state.items;

                if (items.isEmpty) {
                  return MenuEmptyStateWidget(
                    title: 'No Menu Items Found',
                    description: (_searchController.text.isNotEmpty ||
                            _selectedStatus != null)
                        ? 'No items match your search query or filter.'
                        : 'You have not added any menu items to your restaurant yet.',
                    onRefresh: () {
                      _fetchItems();
                    },
                  );
                }

                return MenuItemsListViewWidget(
                  items: items,
                  pagination: state.data.pagination,
                  isLoadingMore: state.isLoadingMore,
                  hasReachedMax: state.hasReachedMax,
                  onLoadMore: () {
                    context.read<ItemsListBloc>().add(LoadMoreItemsListEvent());
                  },
                  onRefresh: () async {
                    _fetchItems();
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
