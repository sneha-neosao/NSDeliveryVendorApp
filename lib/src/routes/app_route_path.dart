enum AppRoute {
  splash(path: "/splash_screen"),
  login(path: "/login"),
  dashboard(path: "/dashboard"),
  orders(path: "/orders"),
  offers(path: "/offers"),
  menu(path: "/menu"),
  settings(path: "/settings"),
  orderDetails(path: "/order_details"),
  slots(path: "/slots"),
  changePassword(path: "/change_password"),
  forgotPassword(path: "/forgot_password"),
  editProfile(path: "/edit_profile"),
  createOffer(path: "/create_offer");

  final String path;

  const AppRoute({required this.path});
}
