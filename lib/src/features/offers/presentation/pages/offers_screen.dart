import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../widgets/offers_header_widget.dart';
import '../widgets/offers_list_view_widget.dart';

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
        BlocProvider(
          create: (_) =>
              getIt<OffersListBloc>()..add(const GetOffersListEvent(page: 1)),
        ),
      ],
      child: const Scaffold(
        backgroundColor: AppColor.white,
        body: Column(
          children: [
            // ── Top Curved Gradient Header ────────────────────────
            OffersHeaderWidget(title: 'Offers'),

            // ── Offers List Content with Shimmer & Pagination ─────
            Expanded(
              child: OffersListViewWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
