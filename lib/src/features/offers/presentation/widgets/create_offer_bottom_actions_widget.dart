import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/app_button_widget.dart';

class CreateOfferBottomActionsWidget extends StatelessWidget {
  final VoidCallback onCreate;
  final bool isLoading;

  const CreateOfferBottomActionsWidget({
    super.key,
    required this.onCreate,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AppButtonWidget(
          text: 'Create Offer',
          onPressed: onCreate,
          isLoading: isLoading,
          width: double.infinity,
          height: 48.h,
          borderRadius: 25.r,
          backgroundColor: AppColor.primary,
        ),
      ),
    );
  }
}
