import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/logger.dart';
import '../../../widgets/app_button_widget.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/profile_update_bloc/profile_update_bloc.dart';
import '../../bloc/profile_update_form_bloc/profile_update_form_bloc.dart';
import '../../bloc/profile_update_image_bloc/profile_update_image_bloc.dart';
import '../../../../remote/models/profile_model/profile_update_image_response.dart';
import '../../../../routes/app_route_path.dart';
import '../widgets/edit_profile_avatar_widget.dart';
import '../widgets/edit_profile_header_widget.dart';
import '../widgets/edit_profile_input_widget.dart';
import '../widgets/edit_profile_shimmer_widget.dart';
import '../widgets/image_picker_bottom_sheet.dart';

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
  File? _selectedImageFile;
  bool _isDataPopulated = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  String _cleanString(String? val) {
    if (val == null) return '';
    final trimmed = val.trim();
    if (trimmed.toLowerCase() == 'null' || trimmed.toLowerCase() == 'string') {
      return '';
    }
    return trimmed;
  }

  void _populateForm(dynamic profile, [BuildContext? blocContext]) {
    if (profile != null) {
      final fName = _cleanString(profile.firstName);
      final mName = _cleanString(profile.middleName);
      final lName = _cleanString(profile.lastName);
      final contact = _cleanString(profile.entityContact);
      final img = _cleanString(profile.entityImage);

      setState(() {
        _isDataPopulated = true;
        _firstNameController.text = fName;
        _middleNameController.text = mName;
        _lastNameController.text = lName;
        _contactController.text = contact;
        if (img.isNotEmpty) {
          _imageUrl = img;
        }
      });

      if (blocContext != null && blocContext.mounted) {
        blocContext.read<ProfileUpdateFormBloc>().add(
              ProfileUpdateInitFormDataEvent(
                firstName: fName,
                middleName: mName,
                lastName: lName,
                contact: contact,
              ),
            );
      }
    }
  }

  Future<void> _handleImagePick(BuildContext blocContext) async {
    try {
      final imageUpdateBloc = blocContext.read<ProfileUpdateImageBloc>();

      final source = await ImagePickerBottomSheet.show(context);
      if (source == null) return;

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Photo',
            toolbarColor: AppColor.primary,
            toolbarWidgetColor: AppColor.pureWhite,
            activeControlsWidgetColor: AppColor.primary,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
          IOSUiSettings(
            title: 'Crop Profile Photo',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        final file = File(croppedFile.path);
        if (mounted) {
          setState(() {
            _selectedImageFile = file;
          });
        }
        logger.d('Image cropped: ${file.path}. Calling Profile Update Image API...');
        imageUpdateBloc.add(UpdateProfileImageEvent(file));
      }
    } catch (e) {
      logger.e('Error picking/cropping image: $e');
    }
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop(true);
    } else {
      context.go(AppRoute.settings.path);
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
        BlocProvider(create: (_) => getIt<ProfileUpdateImageBloc>()),
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccessState) {
                _populateForm(state.data.data, context);
              } else if (state is ProfileFailureState) {
                appSnackBar(
                  context,
                  AppColor.bright_red,
                  state.message,
                );
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
                _handleBack(context);
              } else if (state is ProfileUpdateFailureState) {
                appSnackBar(
                  context,
                  AppColor.bright_red,
                  state.message,
                );
              }
            },
          ),
          BlocListener<ProfileUpdateImageBloc, ProfileUpdateImageState>(
            listener: (context, state) async {
              if (state is ProfileUpdateImageSuccessState) {
                appSnackBar(
                  context,
                  AppColor.green,
                  state.data.message ?? 'Profile image updated successfully',
                );
                final newImg = state.data.data?.entityImage;
                if (newImg != null && newImg.isNotEmpty) {
                  setState(() {
                    _imageUrl = newImg;
                    _selectedImageFile = null;
                  });
                  final session = await SessionManager.getUserSession();
                  if (session?.data?.restaurant != null) {
                    session!.data!.restaurant!.entityImage = newImg;
                    await SessionManager.saveUserSession(session);
                  }
                }
                if (context.mounted) {
                  context.read<ProfileBloc>().add(FetchProfileEvent());
                }
              } else if (state is ProfileUpdateImageFailureState) {
                appSnackBar(
                  context,
                  AppColor.bright_red,
                  state.message,
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                _handleBack(context);
              },
              child: Scaffold(
                backgroundColor: AppColor.white,
                body: Column(
                  children: [
                    // ── Top Header ──────────────────────────────────────────
                    EditProfileHeaderWidget(
                      title: 'Edit Profile',
                      subtitle: 'Update your personal details',
                      onBackTap: () => _handleBack(context),
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
                              BlocBuilder<ProfileUpdateImageBloc,
                                  ProfileUpdateImageState>(
                                builder: (context, imageUpdateState) {
                                  final isImageUpdating = imageUpdateState
                                      is ProfileUpdateImageLoadingState;

                                  return BlocBuilder<ProfileBloc, ProfileState>(
                                    builder: (context, profileState) {
                                      final isProfileLoading =
                                          (profileState is ProfileLoadingState ||
                                                  profileState
                                                      is ProfileInitialState) &&
                                              !_isDataPopulated;

                                      return EditProfileAvatarWidget(
                                        imageUrl: _imageUrl,
                                        imageFile: _selectedImageFile,
                                        isLoading:
                                            isProfileLoading || isImageUpdating,
                                        onEditTap: () =>
                                            _handleImagePick(context),
                                      );
                                    },
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
                                    middleNameController:
                                        _middleNameController,
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
                                    onPressed: () =>
                                        _handleSaveProfile(blocContext),
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
            );
          },
        ),
      ),
    );
  }
}
