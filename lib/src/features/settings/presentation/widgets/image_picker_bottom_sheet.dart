import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

/// Bottom Sheet allowing the vendor to pick a profile photo from Camera or Gallery.
class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({super.key});

  /// Displays the modal bottom sheet and returns the selected [ImageSource], or null if dismissed.
  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ImagePickerBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Grey Close/Cross Button outside at top center
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.charcoal.withValues(alpha: 0.55),
              border: Border.all(
                color: AppColor.pureWhite,
                width: 0.8.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColor.pureWhite,
              size: 20.r,
            ),
          ),
        ),
        12.hS,

        // Bottom Sheet Content Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 20.h,
            left: 20.w,
            right: 20.w,
            bottom: bottomPadding > 0 ? bottomPadding + 14.h : 22.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title & Subtitle
              Text(
                'Change Profile Photo',
                style: AppFont.style(
                  color: AppColor.charcoal,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              4.hS,
              Text(
                'Choose an option to update your photo',
                style: AppFont.style(
                  color: AppColor.slateGrey,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              20.hS,

              // Row Cards: Camera & Gallery
              Row(
                children: [
                  // 1. Camera Card
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.camera_alt_rounded,
                      title: 'Camera',
                      subtitle: 'Take a photo',
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.camera),
                    ),
                  ),
                  14.wS,

                  // 2. Gallery Card
                  Expanded(
                    child: _buildActionCard(
                      context: context,
                      icon: Icons.photo_library_rounded,
                      title: 'Gallery',
                      subtitle: 'From gallery',
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: AppColor.border.withValues(alpha: 0.45),
              width: 1.r,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: AppColor.orangeTint2.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: AppColor.primary,
                    size: 26.r,
                  ),
                ),
              ),
              10.hS,
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppFont.style(
                  color: AppColor.charcoal,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              3.hS,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppFont.style(
                  color: AppColor.slateGrey,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
