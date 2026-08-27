import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class OffersHeaderWidget extends StatelessWidget {
  final String title;

  const OffersHeaderWidget({
    super.key,
    this.title = 'Offers',
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 10.h,
        left: 18.w,
        right: 18.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primary,
            AppColor.darkOrange,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.darkOrange.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_rounded,
            color: AppColor.pureWhite,
            size: 22.r,
          ),
          8.wS,
          Text(
            title,
            softWrap: true,
            style: AppFont.style(
              color: AppColor.pureWhite,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
