import 'package:flutter/material.dart';
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
  void _onItemTapped(BuildContext context, int index) {
    if (index != widget.navigationShell.currentIndex) {
      context.read<BottomNav3Bloc>().add(ChangeBottomNavTabEvent(index));
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      );
    }
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

          return Scaffold(
            backgroundColor: AppColor.white,
            extendBody: true,
            body: widget.navigationShell,
            bottomNavigationBar: CustomBottomNavBar(
              selectedIndex: activeIndex,
              onTabSelected: (index) => _onItemTapped(context, index),
            ),
          );
        },
      ),
    );
  }
}
