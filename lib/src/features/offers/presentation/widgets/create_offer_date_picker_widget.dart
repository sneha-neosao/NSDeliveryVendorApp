import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';

class CreateOfferDatePickerWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? initialDate;

  const CreateOfferDatePickerWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isRequired = false,
    this.onDateSelected,
    this.firstDate,
    this.initialDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final effectiveFirstDate = firstDate ?? DateTime(now.year - 1);
    final effectiveInitialDate = initialDate ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate.isBefore(effectiveFirstDate)
          ? effectiveFirstDate
          : effectiveInitialDate,
      firstDate: effectiveFirstDate,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: AppColor.pureWhite,
              onSurface: AppColor.charcoal,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formatted =
          "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      controller.text = formatted;
      onDateSelected?.call(pickedDate);
    }
  }

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

        // Date Field Input Container
        InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _selectDate(context),
          child: IgnorePointer(
            child: TextFormField(
              controller: controller,
              readOnly: true,
              style: AppFont.style(
                color: AppColor.charcoal,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppFont.style(
                  color: AppColor.slateGrey.withValues(alpha: 0.55),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: Icon(
                  Icons.calendar_month_outlined,
                  color: AppColor.primary,
                  size: 20.r,
                ),
                filled: true,
                fillColor: AppColor.pureWhite,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 13.h,
                  horizontal: 14.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColor.border.withValues(alpha: 0.8),
                    width: 1.r,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColor.border.withValues(alpha: 0.8),
                    width: 1.r,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColor.primary,
                    width: 1.5.r,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
