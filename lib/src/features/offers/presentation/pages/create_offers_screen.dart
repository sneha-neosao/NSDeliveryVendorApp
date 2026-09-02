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
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoute.offers.path);
    }
  }

  void _handleCreateOffer() {
    primaryFocus?.unfocus();
    if (_formKey.currentState?.validate() != true) {
      appSnackBar(
        context,
        AppColor.bright_red,
        'Please fill in all required fields',
      );
      return;
    }

    if (_startDateController.text.trim().isEmpty) {
      appSnackBar(
        context,
        AppColor.bright_red,
        'Please select a start date',
      );
      return;
    }

    if (_endDateController.text.trim().isEmpty) {
      appSnackBar(
        context,
        AppColor.bright_red,
        'Please select an end date',
      );
      return;
    }

    appSnackBar(
      context,
      AppColor.green,
      'Offer "${_promoCodeController.text.trim()}" ready to create',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
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

              // ── Bottom Action (Create Offer Button) ─────────────
              CreateOfferBottomActionsWidget(
                onCreate: _handleCreateOffer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
