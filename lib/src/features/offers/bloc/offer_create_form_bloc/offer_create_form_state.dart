part of 'offer_create_form_bloc.dart';

/// Base state for Offer Create Form Validation BLoC.
///
/// Holds the current form inputs and a validation flag [isValid].
sealed class OfferCreateFormState extends Equatable {
  final String couponCode;
  final String title;
  final String couponType;
  final String discValue;
  final String minOrderValue;
  final String maxDiscountLimit;
  final String startDate;
  final String endDate;
  final String description;
  final String termsCondition;
  final bool isActive;
  final bool isValid;

  const OfferCreateFormState({
    required this.couponCode,
    required this.title,
    required this.couponType,
    required this.discValue,
    required this.minOrderValue,
    required this.maxDiscountLimit,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.termsCondition,
    required this.isActive,
    required this.isValid,
  });

  @override
  List<Object?> get props => [
        couponCode,
        title,
        couponType,
        discValue,
        minOrderValue,
        maxDiscountLimit,
        startDate,
        endDate,
        description,
        termsCondition,
        isActive,
        isValid,
      ];
}

/// Provides a default empty form state with [isValid] set to false.
class OfferCreateFormInitialState extends OfferCreateFormState {
  const OfferCreateFormInitialState()
      : super(
          couponCode: '',
          title: '',
          couponType: 'percentage',
          discValue: '',
          minOrderValue: '',
          maxDiscountLimit: '',
          startDate: '',
          endDate: '',
          description: '',
          termsCondition: '',
          isActive: true,
          isValid: false,
        );
}

/// State representing the current validated data after an input change or initialization.
class OfferCreateFormDataState extends OfferCreateFormState {
  final String inputCouponCode;
  final String inputTitle;
  final String inputCouponType;
  final String inputDiscValue;
  final String inputMinOrderValue;
  final String inputMaxDiscountLimit;
  final String inputStartDate;
  final String inputEndDate;
  final String inputDescription;
  final String inputTermsCondition;
  final bool inputIsActive;
  final bool inputIsValid;

  const OfferCreateFormDataState({
    required this.inputCouponCode,
    required this.inputTitle,
    required this.inputCouponType,
    required this.inputDiscValue,
    required this.inputMinOrderValue,
    required this.inputMaxDiscountLimit,
    required this.inputStartDate,
    required this.inputEndDate,
    required this.inputDescription,
    required this.inputTermsCondition,
    required this.inputIsActive,
    required this.inputIsValid,
  }) : super(
          couponCode: inputCouponCode,
          title: inputTitle,
          couponType: inputCouponType,
          discValue: inputDiscValue,
          minOrderValue: inputMinOrderValue,
          maxDiscountLimit: inputMaxDiscountLimit,
          startDate: inputStartDate,
          endDate: inputEndDate,
          description: inputDescription,
          termsCondition: inputTermsCondition,
          isActive: inputIsActive,
          isValid: inputIsValid,
        );

  @override
  List<Object?> get props => [
        inputCouponCode,
        inputTitle,
        inputCouponType,
        inputDiscValue,
        inputMinOrderValue,
        inputMaxDiscountLimit,
        inputStartDate,
        inputEndDate,
        inputDescription,
        inputTermsCondition,
        inputIsActive,
        inputIsValid,
      ];
}
