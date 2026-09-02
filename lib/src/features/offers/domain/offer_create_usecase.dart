import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/offers_model/offer_create_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class OfferCreateUseCase
    implements UseCase<OfferCreateResponse, OfferCreateParams> {
  final Repository _repository;

  const OfferCreateUseCase(this._repository);

  @override
  Future<Either<Failure, OfferCreateResponse>> call(
      OfferCreateParams params) async {
    return await _repository.offer_create(params);
  }
}

class OfferCreateParams extends Equatable {
  final String couponCode;
  final String title;
  final String couponType;
  final double discValue;
  final double orderValue;
  final String? capLimit;
  final int? perUserLimit;
  final int? useLimit;
  final String startDate;
  final String expiryDate;
  final String? couponDescription;
  final String? termsCondition;
  final bool isActive;
  final int? vendorId;

  const OfferCreateParams({
    required this.couponCode,
    required this.title,
    required this.couponType,
    required this.discValue,
    required this.orderValue,
    this.capLimit,
    this.perUserLimit,
    this.useLimit,
    required this.startDate,
    required this.expiryDate,
    this.couponDescription,
    this.termsCondition,
    this.isActive = true,
    this.vendorId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'coupon_code': couponCode,
      'title': title,
      'coupon_type': couponType,
      'disc_value': discValue,
      'order_value': orderValue,
      'start_date': startDate,
      'expiry_date': expiryDate,
      'is_active': isActive,
    };
    if (capLimit != null && capLimit!.isNotEmpty) {
      map['cap_limit'] = capLimit;
    }
    if (perUserLimit != null) {
      map['per_user_limit'] = perUserLimit;
    }
    if (useLimit != null) {
      map['use_limit'] = useLimit;
    }
    if (couponDescription != null && couponDescription!.isNotEmpty) {
      map['coupon_description'] = couponDescription;
    }
    if (termsCondition != null && termsCondition!.isNotEmpty) {
      map['termscondition'] = termsCondition;
    }
    if (vendorId != null) {
      map['vendor_id'] = vendorId;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        couponCode,
        title,
        couponType,
        discValue,
        orderValue,
        capLimit,
        perUserLimit,
        useLimit,
        startDate,
        expiryDate,
        couponDescription,
        termsCondition,
        isActive,
        vendorId,
      ];
}
