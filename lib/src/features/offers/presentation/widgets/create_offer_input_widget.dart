import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../bloc/offer_create_form_bloc/offer_create_form_bloc.dart';
import 'create_offer_date_picker_widget.dart';
import 'create_offer_dropdown_widget.dart';
import 'create_offer_textfield_widget.dart';

class CreateOfferInputWidget extends StatelessWidget {
  final TextEditingController promoCodeController;
  final TextEditingController titleController;
  final TextEditingController discountValueController;
  final TextEditingController minOrderValueController;
  final TextEditingController maxDiscountLimitController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController descriptionController;
  final TextEditingController termsConditionsController;
  final String selectedDiscountType;
  final bool isActive;
  final ValueChanged<String?> onDiscountTypeChanged;
  final ValueChanged<bool> onIsActiveChanged;

  const CreateOfferInputWidget({
    super.key,
    required this.promoCodeController,
    required this.titleController,
    required this.discountValueController,
    required this.minOrderValueController,
    required this.maxDiscountLimitController,
    required this.startDateController,
    required this.endDateController,
    required this.descriptionController,
    required this.termsConditionsController,
    required this.selectedDiscountType,
    required this.isActive,
    required this.onDiscountTypeChanged,
    required this.onIsActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<OfferCreateFormBloc>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.7),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header: Offer Details ───────────────────────
          Text(
            'Offer Details',
            style: AppFont.style(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.charcoal,
            ),
          ),

          16.hS,

          // 1. Promo Code *
          CreateOfferTextField(
            label: 'Promo Code',
            hintText: 'E.g. SAVE50',
            controller: promoCodeController,
            isRequired: true,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              LengthLimitingTextInputFormatter(20),
            ],
            onChanged: (val) =>
                formBloc.add(OfferCreatePromoCodeChangedEvent(val.trim())),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter promo code';
              }
              return null;
            },
          ),

          14.hS,

          // 2. Offer Title *
          CreateOfferTextField(
            label: 'Offer Title',
            hintText: 'E.g. 50% discount up to ₹150',
            controller: titleController,
            isRequired: true,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) =>
                formBloc.add(OfferCreateTitleChangedEvent(val.trim())),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter offer title';
              }
              return null;
            },
          ),

          14.hS,

          // 3. Discount Type * (Dropdown)
          CreateOfferDropdownWidget(
            label: 'Discount Type',
            selectedValue: selectedDiscountType,
            items: const ['Percentage (%)', 'Flat (₹)'],
            isRequired: true,
            onChanged: (val) {
              onDiscountTypeChanged(val);
              if (val != null) {
                final couponType =
                    val.contains('Percentage') ? 'percentage' : 'flat';
                formBloc.add(OfferCreateDiscountTypeChangedEvent(couponType));
              }
            },
          ),

          14.hS,

          // 4. Discount Value *
          CreateOfferTextField(
            label: 'Discount Value',
            hintText: 'E.g. 50',
            controller: discountValueController,
            isRequired: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (val) =>
                formBloc.add(OfferCreateDiscountValueChangedEvent(val.trim())),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter discount value';
              }
              return null;
            },
          ),

          14.hS,

          // 5. Min. Order Value *
          CreateOfferTextField(
            label: 'Min. Order Value',
            hintText: 'E.g. 299',
            controller: minOrderValueController,
            isRequired: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (val) =>
                formBloc.add(OfferCreateMinOrderValueChangedEvent(val.trim())),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter min. order value';
              }
              return null;
            },
          ),

          14.hS,

          // 6. Maximum Discount Limit (Optional)
          CreateOfferTextField(
            label: 'Maximum Discount Limit',
            hintText: 'E.g. 150',
            controller: maxDiscountLimitController,
            isRequired: false,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onChanged: (val) =>
                formBloc.add(OfferCreateMaxDiscountLimitChangedEvent(val.trim())),
          ),

          14.hS,

          // 7. Start Date *
          CreateOfferDatePickerWidget(
            label: 'Start Date',
            hintText: 'YYYY-MM-DD',
            controller: startDateController,
            isRequired: true,
          ),

          14.hS,

          // 8. End Date *
          CreateOfferDatePickerWidget(
            label: 'End Date',
            hintText: 'YYYY-MM-DD',
            controller: endDateController,
            isRequired: true,
          ),

          14.hS,

          // 9. Description (Optional)
          CreateOfferTextField(
            label: 'Description',
            hintText: 'Enter offer description...',
            controller: descriptionController,
            isRequired: false,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) =>
                formBloc.add(OfferCreateDescriptionChangedEvent(val.trim())),
          ),

          14.hS,

          // 10. Terms & Conditions (Optional)
          CreateOfferTextField(
            label: 'Terms & Conditions',
            hintText: 'Enter terms and conditions...',
            controller: termsConditionsController,
            isRequired: false,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) =>
                formBloc.add(OfferCreateTermsConditionChangedEvent(val.trim())),
          ),

          16.hS,

          // 11. Is Active Toggle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Is Active',
                style: AppFont.style(
                  color: AppColor.charcoal,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.hS,
              Row(
                children: [
                  Transform.scale(
                    scale: 0.85,
                    alignment: Alignment.centerLeft,
                    child: CupertinoSwitch(
                      value: isActive,
                      activeTrackColor: AppColor.primary,
                      inactiveTrackColor: AppColor.gray.withValues(alpha: 0.35),
                      onChanged: (val) {
                        onIsActiveChanged(val);
                        formBloc.add(OfferCreateIsActiveChangedEvent(val));
                      },
                    ),
                  ),
                  8.wS,
                  Text(
                    isActive ? 'Active' : 'Inactive',
                    style: AppFont.style(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isActive ? AppColor.primary : AppColor.slateGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
