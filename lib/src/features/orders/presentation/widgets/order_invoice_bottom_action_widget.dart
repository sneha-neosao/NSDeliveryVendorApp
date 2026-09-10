import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/app_button_widget.dart';

class OrderInvoiceBottomActionWidget extends StatelessWidget {
  final VoidCallback? onDownloadTap;
  final bool isDownloading;

  const OrderInvoiceBottomActionWidget({
    super.key,
    this.onDownloadTap,
    this.isDownloading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 12.h,
        bottom: bottomPadding > 0 ? bottomPadding + 8.h : 16.h,
      ),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppColor.border.withValues(alpha: 0.6),
            width: 1.r,
          ),
        ),
      ),
      child: AppButtonWidget(
        text: 'Download',
        isLoading: isDownloading,
        onPressed: isDownloading ? null : onDownloadTap,
      ),
    );
  }
}
