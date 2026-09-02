import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import 'store_avatar_widget.dart';

class ProfileInfoCardWidget extends StatelessWidget {
  final String storeName;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final bool isLoading;
  final VoidCallback? onEditTap;

  const ProfileInfoCardWidget({
    super.key,
    this.storeName = 'Aashu Snacks Corner',
    this.email = 'aashukale15@gmail.com',
    this.phoneNumber = '+91 98765 43210',
    this.imageUrl,
    this.isLoading = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.35),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Storefront Icon/Avatar
          StoreAvatarWidget(
            size: 72.r,
            imageUrl: imageUrl,
            isLoading: isLoading,
          ),
          14.wS,
          // Vendor Details (Store name, Email, Phone number)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  storeName,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColor.charcoal,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                4.hS,
                Text(
                  email,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColor.slateGrey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                4.hS,
                Text(
                  phoneNumber,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColor.slateGrey,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          10.wS,
          // Orange Edit Button on right side of information
          GestureDetector(
            onTap: onEditTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                Icons.edit_outlined,
                color: AppColor.pureWhite,
                size: 18.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
