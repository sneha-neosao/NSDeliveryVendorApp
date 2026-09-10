import 'package:equatable/equatable.dart';

/// Parameters for opening an order invoice in WebView.
class OrderInvoiceParams extends Equatable {
  final String orderUuid;
  final String orderId;
  final String? token;

  const OrderInvoiceParams({
    required this.orderUuid,
    required this.orderId,
    this.token,
  });

  @override
  List<Object?> get props => [orderUuid, orderId, token];
}
