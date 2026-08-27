import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class AppUpdateDialog extends StatelessWidget {
  final String newVersion;
  final String updateMessage;
  final String storeLink;
  final bool isForceUpdate;

  const AppUpdateDialog({
    super.key,
    required this.newVersion,
    required this.updateMessage,
    required this.storeLink,
    this.isForceUpdate = false,
  });

  static Future<void> show(
    BuildContext context, {
    required String newVersion,
    required String updateMessage,
    required String storeLink,
    bool isForceUpdate = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: !isForceUpdate,
      barrierColor: AppColor.black.withValues(alpha: 0.6),
      builder: (dialogContext) => PopScope(
        canPop: !isForceUpdate,
        child: AppUpdateDialog(
          newVersion: newVersion,
          updateMessage: updateMessage,
          storeLink: storeLink,
          isForceUpdate: isForceUpdate,
        ),
      ),
    );
  }

  Future<void> _launchStore() async {
    if (storeLink.trim().isEmpty) return;
    try {
      final uri = Uri.parse(storeLink.trim());
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = updateMessage.trim().isNotEmpty
        ? updateMessage.trim()
        : 'A new version ($newVersion) is available. Please update the app to continue using the latest features.';

    return Dialog(
      backgroundColor: AppColor.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22.w, 26.h, 22.w, 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top Update Icon ─────────────────────────────────
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                color: AppColor.orangeTint2,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primary.withValues(alpha: 0.2),
                  width: 2.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.system_update_rounded,
                  color: AppColor.primary,
                  size: 34.r,
                ),
              ),
            ),
            16.hS,

            // ── Title with Version ──────────────────────────────
            Text(
              'App Update Available',
              textAlign: TextAlign.center,
              softWrap: true,
              style: AppFont.style(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColor.charcoal,
              ),
            ),
            if (newVersion.isNotEmpty) ...[
              4.hS,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'v$newVersion',
                  style: AppFont.style(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
            12.hS,

            // ── Description / Update Message ────────────────────
            Text(
              message,
              textAlign: TextAlign.center,
              softWrap: true,
              style: AppFont.style(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.slateGrey,
                height: 1.45,
              ),
            ),
            22.hS,

            // ── Action Buttons ──────────────────────────────────
            if (isForceUpdate) ...[
              // Force Update: Only "Update Now" button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _launchStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.pureWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download_rounded,
                          size: 18.r, color: AppColor.pureWhite),
                      8.wS,
                      Text(
                        'Update Now',
                        style: AppFont.style(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.pureWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Flexible Update: "Later" + "Update Now"
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColor.whiteShade,
                          side: BorderSide(
                            color: AppColor.border.withValues(alpha: 0.8),
                            width: 1.r,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'Later',
                          style: AppFont.style(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.charcoal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  12.wS,
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _launchStore();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          foregroundColor: AppColor.pureWhite,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'Update Now',
                          style: AppFont.style(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.pureWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
