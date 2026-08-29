import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/profile_update_form_bloc/profile_update_form_bloc.dart';
import 'edit_profile_textfield_widget.dart';

class EditProfileInputWidget extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  final TextEditingController contactController;

  const EditProfileInputWidget({
    super.key,
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
    required this.contactController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.6),
          width: 1.r,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. First Name (Required)
          EditProfileTextField(
            label: 'First Name',
            hintText: 'Enter first name',
            prefixIcon: Icons.person_outline_rounded,
            controller: firstNameController,
            isRequired: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (val) => context
                .read<ProfileUpdateFormBloc>()
                .add(ProfileUpdateFirstNameChangedEvent(val.trim())),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter first name';
              }
              if (value.trim().length < 2) {
                return 'First name must be at least 2 characters';
              }
              return null;
            },
          ),
          16.hS,

          // 2. Middle Name (Optional)
          EditProfileTextField(
            label: 'Middle Name',
            hintText: 'Enter middle name (optional)',
            prefixIcon: Icons.person_outline_rounded,
            controller: middleNameController,
            isRequired: false,
            textCapitalization: TextCapitalization.words,
            onChanged: (val) => context
                .read<ProfileUpdateFormBloc>()
                .add(ProfileUpdateMiddleNameChangedEvent(val.trim())),
          ),
          16.hS,

          // 3. Last Name (Required)
          EditProfileTextField(
            label: 'Last Name',
            hintText: 'Enter last name',
            prefixIcon: Icons.person_outline_rounded,
            controller: lastNameController,
            isRequired: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (val) => context
                .read<ProfileUpdateFormBloc>()
                .add(ProfileUpdateLastNameChangedEvent(val.trim())),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter last name';
              }
              if (value.trim().length < 2) {
                return 'Last name must be at least 2 characters';
              }
              return null;
            },
          ),
          16.hS,

          // 4. Contact Number (Required)
          EditProfileTextField(
            label: 'Contact Number',
            hintText: 'Enter 10-digit mobile number',
            prefixIcon: Icons.phone_iphone_rounded,
            controller: contactController,
            isRequired: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: (val) => context
                .read<ProfileUpdateFormBloc>()
                .add(ProfileUpdateContactChangedEvent(val.trim())),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter contact number';
              }
              if (value.trim().length != 10) {
                return 'Please enter a valid 10-digit contact number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
