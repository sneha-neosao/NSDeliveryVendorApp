import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class OrderInvoiceWebViewWidget extends StatelessWidget {
  final WebViewController? controller;
  final bool isLoading;
  final int loadingProgress;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const OrderInvoiceWebViewWidget({
    super.key,
    required this.controller,
    required this.isLoading,
    this.loadingProgress = 0,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.orangeTint2,
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 32.r,
                  color: AppColor.primary,
                ),
              ),
              16.hS,
              Text(
                'Unable to load invoice',
                style: AppFont.style(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.charcoal,
                ),
              ),
              8.hS,
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                softWrap: true,
                style: AppFont.style(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.slateGrey,
                ),
              ),
              20.hS,
              if (onRetry != null)
                GestureDetector(
                  onTap: onRetry,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 16.r,
                          color: AppColor.pureWhite,
                        ),
                        6.wS,
                        Text(
                          'Retry',
                          style: AppFont.style(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.pureWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (controller == null) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColor.primary,
          strokeWidth: 2.5.r,
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: controller!),
        if (isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: loadingProgress > 0 ? loadingProgress / 100 : null,
              backgroundColor: AppColor.orangeTint,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primary),
              minHeight: 3.h,
            ),
          ),
      ],
    );
  }
}
