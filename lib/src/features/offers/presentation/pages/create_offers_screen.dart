import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../../../routes/app_route_path.dart';
import '../../bloc/offer_create_bloc/offer_create_bloc.dart';
import '../../bloc/offer_create_form_bloc/offer_create_form_bloc.dart';
import '../../domain/offer_create_usecase.dart';
import '../widgets/create_offer_bottom_actions_widget.dart';
import '../widgets/create_offer_header_widget.dart';
import '../widgets/create_offer_input_widget.dart';

/// Screen for creating a new promotional offer with form validation and details input.
class CreateOffersScreen extends StatefulWidget {
  const CreateOffersScreen({super.key});

  @override
  State<CreateOffersScreen> createState() => _CreateOffersScreenState();
}

class _CreateOffersScreenState extends State<CreateOffersScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _promoCodeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _discountValueController = TextEditingController();
  final TextEditingController _minOrderValueController = TextEditingController();
  final TextEditingController _maxDiscountLimitController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _termsConditionsController =
      TextEditingController();

  String _selectedDiscountType = 'Percentage (%)';
  bool _isActive = true;

  @override
  void dispose() {
    _promoCodeController.dispose();
    _titleController.dispose();
    _discountValueController.dispose();
    _minOrderValueController.dispose();
    _maxDiscountLimitController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    _termsConditionsController.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoute.offers.path);
    }
  }

  void _handleCreateOffer(BuildContext context) {
    primaryFocus?.unfocus();
    final formState = context.read<OfferCreateFormBloc>().state;

    final couponCode = formState.couponCode.isNotEmpty
        ? formState.couponCode
        : _promoCodeController.text.trim();
    final title = formState.title.isNotEmpty
        ? formState.title
        : _titleController.text.trim();
    final couponType = formState.couponType.isNotEmpty
        ? formState.couponType
        : (_selectedDiscountType.contains('Percentage')
            ? 'percentage'
            : 'flat');
    final discValue = double.tryParse(formState.discValue.isNotEmpty
            ? formState.discValue
            : _discountValueController.text.trim()) ??
        0.0;
    final orderValue = double.tryParse(formState.minOrderValue.isNotEmpty
            ? formState.minOrderValue
            : _minOrderValueController.text.trim()) ??
        0.0;
    final capLimit = formState.maxDiscountLimit.isNotEmpty
        ? formState.maxDiscountLimit
        : _maxDiscountLimitController.text.trim();
    final startDate = formState.startDate.isNotEmpty
        ? formState.startDate
        : _startDateController.text.trim();
    final endDate = formState.endDate.isNotEmpty
        ? formState.endDate
        : _endDateController.text.trim();
    final description = formState.description.isNotEmpty
        ? formState.description
        : _descriptionController.text.trim();
    final terms = formState.termsCondition.isNotEmpty
        ? formState.termsCondition
        : _termsConditionsController.text.trim();

    if (couponCode.isEmpty ||
        title.isEmpty ||
        discValue <= 0 ||
        orderValue < 0) {
      appSnackBar(
        context,
        AppColor.bright_red,
        'Please fill in all required fields',
      );
      return;
    }

    if (startDate.isEmpty) {
      appSnackBar(
        context,
        AppColor.bright_red,
        'Please select a start date',
      );
      return;
    }

    if (endDate.isEmpty) {
      appSnackBar(
        context,
        AppColor.bright_red,
        'Please select an end date',
      );
      return;
    }

    final params = OfferCreateParams(
      couponCode: couponCode,
      title: title,
      couponType: couponType,
      discValue: discValue,
      orderValue: orderValue,
      capLimit: capLimit.isNotEmpty ? capLimit : null,
      startDate: startDate,
      expiryDate: endDate,
      couponDescription: description.isNotEmpty ? description : null,
      termsCondition: terms.isNotEmpty ? terms : null,
      isActive: formState.isActive,
    );

    context.read<OfferCreateBloc>().add(CreateOfferSubmitEvent(params));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
        BlocProvider(create: (_) => getIt<OfferCreateBloc>()),
        BlocProvider(create: (_) => getIt<OfferCreateFormBloc>()),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _handleBack(context);
        },
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: Column(
            children: [
              // ── Top Header with Title and Back Button ────────────
              CreateOfferHeaderWidget(
                title: 'Add Promotional Offer',
                subtitle: 'Create a new discount offer for customers',
                onBackTap: () => _handleBack(context),
              ),

              // ── Scrollable Form Container ────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 16.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CreateOfferInputWidget(
                          promoCodeController: _promoCodeController,
                          titleController: _titleController,
                          discountValueController: _discountValueController,
                          minOrderValueController: _minOrderValueController,
                          maxDiscountLimitController:
                              _maxDiscountLimitController,
                          startDateController: _startDateController,
                          endDateController: _endDateController,
                          descriptionController: _descriptionController,
                          termsConditionsController: _termsConditionsController,
                          selectedDiscountType: _selectedDiscountType,
                          isActive: _isActive,
                          onDiscountTypeChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedDiscountType = val;
                              });
                            }
                          },
                          onIsActiveChanged: (val) {
                            setState(() {
                              _isActive = val;
                            });
                          },
                        ),
                        20.hS,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Bottom Action (Create Offer Button with BlocConsumer) ──
              BlocConsumer<OfferCreateBloc, OfferCreateState>(
                listener: (ctx, state) {
                  if (state is OfferCreateFailureState) {
                    appSnackBar(
                      ctx,
                      AppColor.bright_red,
                      state.message,
                    );
                  } else if (state is OfferCreateSuccessState) {
                    appSnackBar(
                      ctx,
                      AppColor.green,
                      state.data.message ?? 'Offer created successfully',
                    );
                    _handleBack(ctx);
                  }
                },
                builder: (ctx, state) {
                  final isLoading = state is OfferCreateLoadingState;
                  return CreateOfferBottomActionsWidget(
                    isLoading: isLoading,
                    onCreate: () => _handleCreateOffer(ctx),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
