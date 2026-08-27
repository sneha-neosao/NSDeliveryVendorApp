class ApiUrl {
  const ApiUrl._();

  // static const baseUrl = "http://192.168.1.17:8001/api/v1/delivery_boy"; // TEST
  static const baseUrl = "https://web.neosao.co.in/api/v1/restaurant"; // LIVE

  // static const socketUrl = "http://172.20.10.2:8001"; // Socket
  static const socketUrl = "https://web.neosao.co.in"; // Socket

  static const login = "/auth/login";

  static const logout = "/auth/logout";

  static const forgotPassword = "/auth/forgot-password";

  static const itemsList = "/items/list";

  static const orderHistory = "/orders/history";

  static const ordersList = "/orders/list";

  static const orderDetails = "/orders/detail";

  static const orderUpdateStatus = "/orders/update-status";

  static const serviceabilityUpdate = "/serviceability/update";

  static const slotsList = "/slots/list";

  static const slotCreate = "/slots/create";

  static const slotUpdate = "/slots/update";

  static const slotDelete = "/slots/delete";

  static const profileList = "/profile/list";

  static const dashboardSummaryStats = "/dashboard/summary-stats";

  static const dashboardPerformanceMetrics = "/dashboard/performance-metrics";

  static const offersList = "/offers/list";

  static const updateFirebaseToken = "/auth/update-firebase-token";

  static const deleteAccount = "/auth/delete-account";
}

