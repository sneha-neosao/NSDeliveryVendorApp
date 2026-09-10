import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../domain/models/order_invoice_params.dart';
import '../widgets/order_invoice_bottom_action_widget.dart';
import '../widgets/order_invoice_header_widget.dart';
import '../widgets/order_invoice_web_view_widget.dart';

class OrderInvoiceScreen extends StatefulWidget {
  final OrderInvoiceParams? params;

  const OrderInvoiceScreen({
    super.key,
    required this.params,
  });

  @override
  State<OrderInvoiceScreen> createState() => _OrderInvoiceScreenState();
}

class _OrderInvoiceScreenState extends State<OrderInvoiceScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _isDownloading = false;
  int _loadingProgress = 0;
  String? _errorMessage;
  String _invoiceUrl = '';

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    final orderUuid = widget.params?.orderUuid ?? '';
    var token = widget.params?.token ?? '';

    if (token.isEmpty) {
      token = await SessionManager.getAuthToken() ?? '';
    }

    if (orderUuid.isNotEmpty) {
      _invoiceUrl = ApiUrl.orderInvoice(orderUuid, token);
      // ignore: avoid_print
      print("===== INVOICE WEBVIEW URL: $_invoiceUrl =====");
      _setupWebViewController(_invoiceUrl);
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Order identifier is missing.';
        });
      }
    }
  }

  void _setupWebViewController(String url) {
    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(AppColor.pureWhite)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _loadingProgress = progress;
                });
              }
            },
            onPageStarted: (String url) {
              // ignore: avoid_print
              print("===== WEBVIEW PAGE STARTED: $url =====");
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = error.description;
                });
              }
            },
          ),
        );

      controller.loadRequest(Uri.parse(url));

      if (mounted) {
        setState(() {
          _controller = controller;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to initialize WebView: $e';
        });
      }
    }
  }

  String _formatTitle() {
    final rawId = widget.params?.orderId ?? '';
    if (rawId.isEmpty) return 'ORD_';
    if (rawId.toUpperCase().startsWith('ORD_')) {
      return rawId.toUpperCase();
    }
    return 'ORD_$rawId';
  }

  Future<void> _handleDownload() async {
    if (_isDownloading) return;
    if (_invoiceUrl.isEmpty) {
      appSnackBar(context, AppColor.bright_red, 'Invoice URL is not available.');
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    final orderId = widget.params?.orderId ?? 'invoice';
    final safeOrderId = orderId.replaceAll(RegExp(r'[\\/:*?"<>|]'), '');
    final notificationId = safeOrderId.hashCode.abs().remainder(100000);

    try {
      // 1. Request permissions if running on Android
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          await Permission.storage.request();
        }
        final notifStatus = await Permission.notification.status;
        if (!notifStatus.isGranted) {
          await Permission.notification.request();
        }
      }

      // 2. Resolve App Name & create/ensure folder exists
      String appName = 'NS Delivery Vendor';
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        if (packageInfo.appName.isNotEmpty) {
          appName = packageInfo.appName;
        }
      } catch (_) {}

      Directory? baseDir;
      if (Platform.isAndroid) {
        final publicDownload = Directory('/storage/emulated/0/Download');
        if (await publicDownload.exists()) {
          baseDir = publicDownload;
        } else {
          baseDir = await getExternalStorageDirectory();
        }
      } else {
        baseDir = await getApplicationDocumentsDirectory();
      }
      baseDir ??= await getApplicationDocumentsDirectory();

      final appFolder = Directory('${baseDir.path}/$appName');
      if (!await appFolder.exists()) {
        await appFolder.create(recursive: true);
      }

      final fileName = 'ORD_${safeOrderId}_invoice.pdf';
      final savePath = '${appFolder.path}/$fileName';

      // 3. Show initial download notification
      await NoficationService.showDownloadProgressNotification(
        id: notificationId,
        title: 'Downloading Invoice ORD_$safeOrderId',
        body: '0%',
        progress: 0,
        maxProgress: 100,
      );

      // 4. Download file using Dio with progress tracking
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      await dio.download(
        _invoiceUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = ((received / total) * 100).toInt();
            NoficationService.showDownloadProgressNotification(
              id: notificationId,
              title: 'Downloading Invoice ORD_$safeOrderId',
              body: '$progress%',
              progress: progress,
              maxProgress: 100,
            );
          } else {
            final kb = (received / 1024).toStringAsFixed(1);
            NoficationService.showDownloadProgressNotification(
              id: notificationId,
              title: 'Downloading Invoice ORD_$safeOrderId',
              body: '$kb KB downloaded',
              progress: 0,
              maxProgress: 0,
            );
          }
        },
      );

      // 5. Complete notification
      await NoficationService.showDownloadCompleteNotification(
        id: notificationId,
        title: 'Invoice Downloaded',
        body: 'Saved to $appName/$fileName',
        payload: savePath,
      );

      if (mounted) {
        appSnackBar(
          context,
          AppColor.green,
          'Invoice saved to $appName/$fileName',
        );
      }
    } catch (e) {
      await NoficationService.cancelNotification(notificationId);
      if (mounted) {
        appSnackBar(
          context,
          AppColor.bright_red,
          'Failed to download invoice: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: Scaffold(
        backgroundColor: AppColor.pureWhite,
        body: Column(
          children: [
            // ── Top Curved Gradient Header (ORD_<order_id>) ──
            OrderInvoiceHeaderWidget(
              title: _formatTitle(),
              subtitle: 'Invoice',
              onRefreshTap: () {
                if (_controller != null) {
                  _controller!.reload();
                } else if (_invoiceUrl.isNotEmpty) {
                  _setupWebViewController(_invoiceUrl);
                }
              },
            ),

            // ── WebView Content ──
            Expanded(
              child: OrderInvoiceWebViewWidget(
                controller: _controller,
                isLoading: _isLoading,
                loadingProgress: _loadingProgress,
                errorMessage: _errorMessage,
                onRetry: () {
                  if (_invoiceUrl.isNotEmpty) {
                    _setupWebViewController(_invoiceUrl);
                  } else {
                    _initAndLoad();
                  }
                },
              ),
            ),

            // ── Bottom Download Button ──
            OrderInvoiceBottomActionWidget(
              isDownloading: _isDownloading,
              onDownloadTap: _handleDownload,
            ),
          ],
        ),
      ),
    );
  }
}
