import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class CreateOfferDropdownWidget extends StatelessWidget {
  final String label;
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isRequired;

  const CreateOfferDropdownWidget({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label with Required Star
        Row(
          children: [
            Text(
              label,
              style: AppFont.style(
                color: AppColor.charcoal,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired) ...[
              3.wS,
              Text(
                '*',
                style: AppFont.style(
                  color: AppColor.bright_red,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        6.hS,

        // Dropdown Container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColor.border.withValues(alpha: 0.8),
              width: 1.r,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(selectedValue) ? selectedValue : items.first,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColor.charcoal,
                size: 22.r,
              ),
              style: AppFont.style(
                color: AppColor.charcoal,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(12.r),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: AppFont.style(
                      color: AppColor.charcoal,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
