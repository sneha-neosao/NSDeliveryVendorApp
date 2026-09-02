import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';

part 'offer_create_form_event.dart';
part 'offer_create_form_state.dart';

/// Handles validation and state logic for **Offer Create Form Inputs**.
class OfferCreateFormBloc
    extends Bloc<OfferCreateFormEvent, OfferCreateFormState> {
  OfferCreateFormBloc() : super(const OfferCreateFormInitialState()) {
    on<OfferCreatePromoCodeChangedEvent>(_promoCodeChanged);
    on<OfferCreateTitleChangedEvent>(_titleChanged);
    on<OfferCreateDiscountTypeChangedEvent>(_discountTypeChanged);
    on<OfferCreateDiscountValueChangedEvent>(_discountValueChanged);
    on<OfferCreateMinOrderValueChangedEvent>(_minOrderValueChanged);
    on<OfferCreateMaxDiscountLimitChangedEvent>(_maxDiscountLimitChanged);
    on<OfferCreateStartDateChangedEvent>(_startDateChanged);
    on<OfferCreateEndDateChangedEvent>(_endDateChanged);
    on<OfferCreateDescriptionChangedEvent>(_descriptionChanged);
    on<OfferCreateTermsConditionChangedEvent>(_termsConditionChanged);
    on<OfferCreateIsActiveChangedEvent>(_isActiveChanged);
    on<OfferCreateInitFormDataEvent>(_initFormData);
    on<OfferCreateResetFormEvent>(_resetForm);
  }

  Future<void> _promoCodeChanged(
      OfferCreatePromoCodeChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: event.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: event.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _titleChanged(
      OfferCreateTitleChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: event.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: event.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _discountTypeChanged(
      OfferCreateDiscountTypeChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: event.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: event.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _discountValueChanged(
      OfferCreateDiscountValueChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: event.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: event.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _minOrderValueChanged(
      OfferCreateMinOrderValueChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: event.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: event.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _maxDiscountLimitChanged(
      OfferCreateMaxDiscountLimitChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: event.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _startDateChanged(
      OfferCreateStartDateChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: event.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: event.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _endDateChanged(
      OfferCreateEndDateChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: event.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: event.endDate,
        ),
      ),
    );
  }

  Future<void> _descriptionChanged(
      OfferCreateDescriptionChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: event.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _termsConditionChanged(
      OfferCreateTermsConditionChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: event.termsCondition,
        inputIsActive: state.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _isActiveChanged(
      OfferCreateIsActiveChangedEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(
      OfferCreateFormDataState(
        inputCouponCode: state.couponCode,
        inputTitle: state.title,
        inputCouponType: state.couponType,
        inputDiscValue: state.discValue,
        inputMinOrderValue: state.minOrderValue,
        inputMaxDiscountLimit: state.maxDiscountLimit,
        inputStartDate: state.startDate,
        inputEndDate: state.endDate,
        inputDescription: state.description,
        inputTermsCondition: state.termsCondition,
        inputIsActive: event.isActive,
        inputIsValid: inputValidator(
          couponCode: state.couponCode,
          title: state.title,
          couponType: state.couponType,
          discValue: state.discValue,
          minOrderValue: state.minOrderValue,
          startDate: state.startDate,
          endDate: state.endDate,
        ),
      ),
    );
  }

  Future<void> _initFormData(
      OfferCreateInitFormDataEvent event, Emitter<OfferCreateFormState> emit) async {
    final couponCode = event.couponCode ?? state.couponCode;
    final title = event.title ?? state.title;
    final couponType = event.couponType ?? state.couponType;
    final discValue = event.discValue ?? state.discValue;
    final minOrderValue = event.minOrderValue ?? state.minOrderValue;
    final maxDiscountLimit = event.maxDiscountLimit ?? state.maxDiscountLimit;
    final startDate = event.startDate ?? state.startDate;
    final endDate = event.endDate ?? state.endDate;
    final description = event.description ?? state.description;
    final termsCondition = event.termsCondition ?? state.termsCondition;
    final isActive = event.isActive ?? state.isActive;

    emit(
      OfferCreateFormDataState(
        inputCouponCode: couponCode,
        inputTitle: title,
        inputCouponType: couponType,
        inputDiscValue: discValue,
        inputMinOrderValue: minOrderValue,
        inputMaxDiscountLimit: maxDiscountLimit,
        inputStartDate: startDate,
        inputEndDate: endDate,
        inputDescription: description,
        inputTermsCondition: termsCondition,
        inputIsActive: isActive,
        inputIsValid: inputValidator(
          couponCode: couponCode,
          title: title,
          couponType: couponType,
          discValue: discValue,
          minOrderValue: minOrderValue,
          startDate: startDate,
          endDate: endDate,
        ),
      ),
    );
  }

  Future<void> _resetForm(
      OfferCreateResetFormEvent event, Emitter<OfferCreateFormState> emit) async {
    emit(const OfferCreateFormInitialState());
  }

  bool inputValidator({
    required String couponCode,
    required String title,
    required String couponType,
    required String discValue,
    required String minOrderValue,
    required String startDate,
    required String endDate,
  }) {
    final hasCouponCode = couponCode.trim().isNotEmpty;
    final hasTitle = title.trim().isNotEmpty;
    final hasDiscValue =
        discValue.trim().isNotEmpty && (double.tryParse(discValue.trim()) ?? 0) > 0;
    final hasMinOrderValue = minOrderValue.trim().isNotEmpty &&
        (double.tryParse(minOrderValue.trim()) ?? -1) >= 0;
    final hasStartDate = startDate.trim().isNotEmpty;
    final hasEndDate = endDate.trim().isNotEmpty;

    return hasCouponCode &&
        hasTitle &&
        hasDiscValue &&
        hasMinOrderValue &&
        hasStartDate &&
        hasEndDate;
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE OfferCreateFormBloc =====");
    return super.close();
  }
}
