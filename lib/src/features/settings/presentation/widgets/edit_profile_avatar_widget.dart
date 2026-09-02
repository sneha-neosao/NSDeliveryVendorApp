import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_color.dart';

/// Circular Avatar Widget with orange border and white edit icon for the Edit Profile screen.
class EditProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isLoading;
  final double? size;
  final VoidCallback? onEditTap;

  const EditProfileAvatarWidget({
    super.key,
    this.imageUrl,
    this.isLoading = false,
    this.size,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? 100.r;
    final hasImage = imageUrl != null &&
        imageUrl!.trim().isNotEmpty &&
        imageUrl!.trim().toLowerCase() != 'null' &&
        imageUrl!.trim().toLowerCase() != 'string';

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Circular Avatar Container with Orange Border
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.pureWhite,
              border: Border.all(
                color: AppColor.primary,
                width: 3.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: EdgeInsets.all(3.r),
            child: ClipOval(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColor.orangeTint2.withValues(alpha: 0.5),
                child: isLoading
                    ? Shimmer.fromColors(
                        baseColor: AppColor.border.withValues(alpha: 0.35),
                        highlightColor: AppColor.pureWhite,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppColor.pureWhite,
                        ),
                      )
                    : hasImage
                        ? Image.network(
                            imageUrl!.trim(),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                baseColor:
                                    AppColor.border.withValues(alpha: 0.35),
                                highlightColor: AppColor.pureWhite,
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: AppColor.pureWhite,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: AppColor.primary,
                                size: (avatarSize * 0.48).r,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: AppColor.primary,
                              size: (avatarSize * 0.48).r,
                            ),
                          ),
              ),
            ),
          ),

          // White Edit Icon Badge with Orange Background & White Border
          Positioned(
            bottom: 2.r,
            right: 2.r,
            child: GestureDetector(
              onTap: onEditTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary,
                  border: Border.all(
                    color: AppColor.pureWhite,
                    width: 2.r,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.18),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.edit_rounded,
                    color: AppColor.pureWhite,
                    size: 15.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
