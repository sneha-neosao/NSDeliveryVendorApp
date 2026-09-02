part of 'offer_create_form_bloc.dart';

/// Base class for all Offer Create form input events
sealed class OfferCreateFormEvent extends Equatable {
  const OfferCreateFormEvent();

  @override
  List<Object?> get props => [];
}

/// Listens for changes in promo code input
class OfferCreatePromoCodeChangedEvent extends OfferCreateFormEvent {
  final String couponCode;

  const OfferCreatePromoCodeChangedEvent(this.couponCode);

  @override
  List<Object?> get props => [couponCode];
}

/// Listens for changes in offer title input
class OfferCreateTitleChangedEvent extends OfferCreateFormEvent {
  final String title;

  const OfferCreateTitleChangedEvent(this.title);

  @override
  List<Object?> get props => [title];
}

/// Listens for changes in discount type (percentage / flat)
class OfferCreateDiscountTypeChangedEvent extends OfferCreateFormEvent {
  final String couponType;

  const OfferCreateDiscountTypeChangedEvent(this.couponType);

  @override
  List<Object?> get props => [couponType];
}

/// Listens for changes in discount value input
class OfferCreateDiscountValueChangedEvent extends OfferCreateFormEvent {
  final String discValue;

  const OfferCreateDiscountValueChangedEvent(this.discValue);

  @override
  List<Object?> get props => [discValue];
}

/// Listens for changes in minimum order value input
class OfferCreateMinOrderValueChangedEvent extends OfferCreateFormEvent {
  final String minOrderValue;

  const OfferCreateMinOrderValueChangedEvent(this.minOrderValue);

  @override
  List<Object?> get props => [minOrderValue];
}

/// Listens for changes in maximum discount limit input
class OfferCreateMaxDiscountLimitChangedEvent extends OfferCreateFormEvent {
  final String maxDiscountLimit;

  const OfferCreateMaxDiscountLimitChangedEvent(this.maxDiscountLimit);

  @override
  List<Object?> get props => [maxDiscountLimit];
}

/// Listens for changes in start date input
class OfferCreateStartDateChangedEvent extends OfferCreateFormEvent {
  final String startDate;

  const OfferCreateStartDateChangedEvent(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

/// Listens for changes in end date input
class OfferCreateEndDateChangedEvent extends OfferCreateFormEvent {
  final String endDate;

  const OfferCreateEndDateChangedEvent(this.endDate);

  @override
  List<Object?> get props => [endDate];
}

/// Listens for changes in description input
class OfferCreateDescriptionChangedEvent extends OfferCreateFormEvent {
  final String description;

  const OfferCreateDescriptionChangedEvent(this.description);

  @override
  List<Object?> get props => [description];
}

/// Listens for changes in terms & conditions input
class OfferCreateTermsConditionChangedEvent extends OfferCreateFormEvent {
  final String termsCondition;

  const OfferCreateTermsConditionChangedEvent(this.termsCondition);

  @override
  List<Object?> get props => [termsCondition];
}

/// Listens for changes in isActive toggle
class OfferCreateIsActiveChangedEvent extends OfferCreateFormEvent {
  final bool isActive;

  const OfferCreateIsActiveChangedEvent(this.isActive);

  @override
  List<Object?> get props => [isActive];
}

/// Event to populate or reset form data
class OfferCreateInitFormDataEvent extends OfferCreateFormEvent {
  final String? couponCode;
  final String? title;
  final String? couponType;
  final String? discValue;
  final String? minOrderValue;
  final String? maxDiscountLimit;
  final String? startDate;
  final String? endDate;
  final String? description;
  final String? termsCondition;
  final bool? isActive;

  const OfferCreateInitFormDataEvent({
    this.couponCode,
    this.title,
    this.couponType,
    this.discValue,
    this.minOrderValue,
    this.maxDiscountLimit,
    this.startDate,
    this.endDate,
    this.description,
    this.termsCondition,
    this.isActive,
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
      ];
}

/// Event to reset form to initial blank state
class OfferCreateResetFormEvent extends OfferCreateFormEvent {}
