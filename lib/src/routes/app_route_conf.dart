import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'app_route_path.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> globalNavigator = GlobalKey<NavigatorState>();

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    navigatorKey: globalNavigator,
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        pageBuilder: (context, state) => _fadePage(const SplashScreen()),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (context, state) => _fadePage(const LoginScreen()),
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        pageBuilder: (context, state) => _fadePage(const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoute.orderDetails.path,
        name: AppRoute.orderDetails.name,
        pageBuilder: (context, state) {
          final uuId = state.extra as String? ?? '';
          return _fadePage(OrderDetailsScreen(uuId: uuId));
        },
      ),
      GoRoute(
        path: AppRoute.slots.path,
        name: AppRoute.slots.name,
        pageBuilder: (context, state) {
          return _fadePage(const SlotScreen());
        },
      ),
      GoRoute(
        path: AppRoute.changePassword.path,
        name: AppRoute.changePassword.name,
        pageBuilder: (context, state) {
          return _fadePage(const ChangePasswordScreen());
        },
      ),
      GoRoute(
        path: AppRoute.forgotPassword.path,
        name: AppRoute.forgotPassword.name,
        pageBuilder: (context, state) {
          return _fadePage(const ForgotPasswordScreen());
        },
      ),
      GoRoute(
        path: AppRoute.editProfile.path,
        name: AppRoute.editProfile.name,
        pageBuilder: (context, state) {
          return _fadePage(const EditProfileScreen());
        },
      ),
      GoRoute(
        path: AppRoute.createOffer.path,
        name: AppRoute.createOffer.name,
        pageBuilder: (context, state) {
          return _fadePage(const CreateOffersScreen());
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.dashboard.path,
                name: AppRoute.dashboard.name,
                pageBuilder: (context, state) =>
                    _fadePage(const DashboardScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.orders.path,
                name: AppRoute.orders.name,
                pageBuilder: (context, state) =>
                    _fadePage(const OrdersScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.offers.path,
                name: AppRoute.offers.name,
                pageBuilder: (context, state) =>
                    _fadePage(const OffersScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.menu.path,
                name: AppRoute.menu.name,
                pageBuilder: (context, state) =>
                    _fadePage(const MenuScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Fade transition page helper

CustomTransitionPage _fadePage(Widget child) => CustomTransitionPage(
  transitionDuration: const Duration(
    milliseconds: 500,
  ), // Duration of the animation
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut, // Smooth in-out fade
    );

    return FadeTransition(opacity: curvedAnimation, child: child);
  },
);
