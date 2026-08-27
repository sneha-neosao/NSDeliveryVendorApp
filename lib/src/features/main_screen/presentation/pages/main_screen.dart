import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/bottom_nav_bloc.dart';
import '../../bloc/bottom_nav_event.dart';
import '../../bloc/bottom_nav_state.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isBottomNavVisible = true;

  void _onItemTapped(BuildContext context, int index) {
    if (index != widget.navigationShell.currentIndex) {
      if (!_isBottomNavVisible) {
        setState(() {
          _isBottomNavVisible = true;
        });
      }
      context.read<BottomNav3Bloc>().add(ChangeBottomNavTabEvent(index));
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      );
    }
  }

  bool _handleScrollNotification(UserScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification.direction == ScrollDirection.reverse) {
      // User is scrolling down (moving content up) -> Smoothly glide hide bottom nav
      if (_isBottomNavVisible) {
        setState(() {
          _isBottomNavVisible = false;
        });
      }
    } else if (notification.direction == ScrollDirection.forward) {
      // User is scrolling up (moving content down / towards top) -> Smoothly glide show bottom nav
      if (!_isBottomNavVisible) {
        setState(() {
          _isBottomNavVisible = true;
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<BottomNav3Bloc>()),
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
      ],
      child: BlocBuilder<BottomNav3Bloc, BottomNavState>(
        builder: (context, state) {
          final activeIndex = widget.navigationShell.currentIndex;

          return PopScope(
            canPop: activeIndex == 0,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              // If on any tab other than Dashboard (index 0), navigate to Dashboard
              if (activeIndex != 0) {
                _onItemTapped(context, 0);
              }
            },
            child: Scaffold(
              backgroundColor: AppColor.white,
              extendBody: false,
              body: NotificationListener<UserScrollNotification>(
                onNotification: _handleScrollNotification,
                child: widget.navigationShell,
              ),
              bottomNavigationBar: AnimatedSlide(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOutCubic,
                offset:
                    _isBottomNavVisible ? Offset.zero : const Offset(0, 1.5),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOut,
                  opacity: _isBottomNavVisible ? 1.0 : 0.0,
                  child: IgnorePointer(
                    ignoring: !_isBottomNavVisible,
                    child: CustomBottomNavBar(
                      selectedIndex: activeIndex,
                      onTabSelected: (index) => _onItemTapped(context, index),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
