class ApiUrl {
  const ApiUrl._();

  // static const baseUrl = "http://172.20.10.2:8001/api/v1/delivery_boy"; // TEST
  static const baseUrl = "https://web.neosao.co.in/api/v1/restaurant"; // LIVE

  // static const socketUrl = "http://172.20.10.2:8001"; // Socket
  static const socketUrl = "https://web.neosao.co.in"; // Socket

  static const login = "/auth/login";

  static const logout = "/auth/logout";

  static const itemsList = "/items/list";

  static const orderHistory = "/orders/history";

  static const ordersList = "/orders/list";

  static const orderDetails = "/orders/detail";

  static const serviceabilityUpdate = "/serviceability/update";

  static const slotsList = "/slots/list";

  static const slotCreate = "/slots/create";

  static const slotUpdate = "/slots/update";

  static const slotDelete = "/slots/delete";
}

