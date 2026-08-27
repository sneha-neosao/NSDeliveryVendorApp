import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/offers_empty_state_widget.dart';
import '../widgets/offers_header_widget.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeBloc>()),
        BlocProvider(create: (_) => getIt<TranslateBloc>()),
      ],
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // ── Top Curved Gradient Header ────────────────────────
            const OffersHeaderWidget(title: 'Offers'),

            // ── Body Content ──────────────────────────────────────
            Expanded(
              child: RefreshIndicator(
                color: AppColor.primary,
                backgroundColor: AppColor.pureWhite,
                onRefresh: () async {
                  // Hook for future offers API refresh
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 18.w,
                    right: 18.w,
                    top: 14.h,
                    bottom: 16.h,
                  ),
                  child: const OffersEmptyStateWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
