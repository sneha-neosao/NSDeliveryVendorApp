enum AppRoute {
  splash(path: "/splash_screen"),
  login(path: "/login"),
  dashboard(path: "/dashboard"),
  orders(path: "/orders"),
  menu(path: "/menu"),
  settings(path: "/settings"),
  orderDetails(path: "/order_details");

  final String path;

  const AppRoute({required this.path});
}
