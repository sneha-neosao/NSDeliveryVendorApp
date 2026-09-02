import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_color.dart';

class StoreAvatarWidget extends StatelessWidget {
  final double? size;
  final String? imageUrl;
  final bool isLoading;

  const StoreAvatarWidget({
    super.key,
    this.size,
    this.imageUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? 82.r;
    final hasImage = imageUrl != null &&
        imageUrl!.trim().isNotEmpty &&
        imageUrl!.trim().toLowerCase() != 'null' &&
        imageUrl!.trim().toLowerCase() != 'string';

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(10.r),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: AppColor.border.withValues(alpha: 0.35),
                  highlightColor: AppColor.pureWhite,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.pureWhite,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColor.orangeTint2.withValues(alpha: 0.5),
                  child: hasImage
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
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.storefront_rounded,
                              color: AppColor.primary,
                              size: (avatarSize * 0.5).r,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColor.primary,
                            size: (avatarSize * 0.5).r,
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}
