import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/app_button_widget.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/profile_update_bloc/profile_update_bloc.dart';
import '../../bloc/profile_update_form_bloc/profile_update_form_bloc.dart';
import '../widgets/edit_profile_avatar_widget.dart';
import '../widgets/edit_profile_header_widget.dart';
import '../widgets/edit_profile_input_widget.dart';
import '../widgets/edit_profile_shimmer_widget.dart';

/// Edit Profile Screen displaying form inputs for First Name, Middle Name, Last Name, and Contact Number.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _imageUrl;
  bool _isDataPopulated = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSessionData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  /// Sanitizes API values: ignores "string", "null", or empty strings so textfields stay empty with hints
  String? _cleanString(String? val) {
    if (val == null) return null;
    final trimmed = val.trim();
    if (trimmed.isEmpty ||
        trimmed.toLowerCase() == 'string' ||
        trimmed.toLowerCase() == 'null') {
      return null;
    }
    return trimmed;
  }

  Future<void> _loadInitialSessionData() async {
    final session = await SessionManager.getUserSession();
    final restaurant = session?.data?.restaurant;

    if (restaurant != null && mounted && !_isDataPopulated) {
      setState(() {
        final fName = _cleanString(restaurant.firstName);
        final mName = _cleanString(restaurant.middleName);
        final lName = _cleanString(restaurant.lastName);
        final img = _cleanString(restaurant.entityImage);

        if (_firstNameController.text.isEmpty && fName != null) {
          _firstNameController.text = fName;
        }
        if (_middleNameController.text.isEmpty && mName != null) {
          _middleNameController.text = mName;
        }
        if (_lastNameController.text.isEmpty && lName != null) {
          _lastNameController.text = lName;
        }
        if (img != null) {
          _imageUrl = img;
        }
      });
    }
  }

  void _handleSaveProfile(BuildContext blocContext) {
    primaryFocus?.unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      blocContext.read<ProfileUpdateBloc>().add(
            UpdateProfileEvent(
              firstName: _firstNameController.text.trim(),
              middleName: _middleNameController.text.trim().isNotEmpty
                  ? _middleNameController.text.trim()
                  : null,
              lastName: _lastNameController.text.trim(),
              entityContact: _contactController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ProfileBloc>()..add(FetchProfileEvent()),
        ),
        BlocProvider(create: (_) => getIt<ProfileUpdateBloc>()),
        BlocProvider(create: (_) => getIt<ProfileUpdateFormBloc>()),
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccessState) {
                final profile = state.data.data;
                if (profile != null && mounted && !_isDataPopulated) {
                  setState(() {
                    _isDataPopulated = true;
                    final fName = _cleanString(profile.firstName);
                    final mName = _cleanString(profile.middleName);
                    final lName = _cleanString(profile.lastName);
                    final contact = _cleanString(profile.entityContact);
                    final img = _cleanString(profile.entityImage);

                    _firstNameController.text = fName ?? '';
                    _middleNameController.text = mName ?? '';
                    _lastNameController.text = lName ?? '';
                    _contactController.text = contact ?? '';
                    if (img != null) _imageUrl = img;
                  });

                  context.read<ProfileUpdateFormBloc>().add(
                        ProfileUpdateInitFormDataEvent(
                          firstName: _firstNameController.text,
                          middleName: _middleNameController.text,
                          lastName: _lastNameController.text,
                          contact: _contactController.text,
                        ),
                      );
                }
              }
            },
          ),
          BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccessState) {
                appSnackBar(
                  context,
                  AppColor.green,
                  state.data.message ?? 'Profile updated successfully',
                );
                context.pop(true);
              } else if (state is ProfileUpdateFailureState) {
                appSnackBar(
                  context,
                  AppColor.bright_red,
                  state.message,
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColor.white,
          body: Column(
            children: [
              // ── Top Header ──────────────────────────────────────────
              const EditProfileHeaderWidget(
                title: 'Edit Profile',
                subtitle: 'Update your personal details',
              ),

              // ── Scrollable Form Body ────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 20.h,
                    bottom: 24.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circular Profile Image with Orange Border
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, profileState) {
                            final isProfileLoading =
                                (profileState is ProfileLoadingState ||
                                        profileState is ProfileInitialState) &&
                                    !_isDataPopulated;

                            return EditProfileAvatarWidget(
                              imageUrl: _imageUrl,
                              isLoading: isProfileLoading,
                            );
                          },
                        ),
                        20.hS,

                        // Input Form Container with Shimmer
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, profileState) {
                            if ((profileState is ProfileLoadingState ||
                                    profileState is ProfileInitialState) &&
                                !_isDataPopulated) {
                              return const EditProfileShimmerWidget();
                            }

                            return EditProfileInputWidget(
                              firstNameController: _firstNameController,
                              middleNameController: _middleNameController,
                              lastNameController: _lastNameController,
                              contactController: _contactController,
                            );
                          },
                        ),
                        28.hS,

                        // Save Changes Button with Loader
                        BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
                          builder: (blocContext, updateState) {
                            final isLoading =
                                updateState is ProfileUpdateLoadingState;

                            return AppButtonWidget(
                              text: 'Save Changes',
                              isLoading: isLoading,
                              onPressed: () => _handleSaveProfile(blocContext),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
