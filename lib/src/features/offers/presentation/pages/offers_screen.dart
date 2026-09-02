import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/blocs/theme/theme_bloc.dart';
import '../../../../core/blocs/translate/translate_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/snackbar_widget.dart';
import '../../../../routes/app_route_path.dart';
import '../widgets/offers_add_fab_widget.dart';
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
        BlocProvider(
          create: (_) => getIt<OfferStatusToggleBloc>(),
        ),
      ],
      child: const _OffersContentWidget(),
    );
  }
}

class _OffersContentWidget extends StatelessWidget {
  const _OffersContentWidget();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OfferStatusToggleBloc, OfferStatusToggleState>(
      listener: (context, toggleState) {
        if (toggleState is OfferStatusToggleSuccessState) {
          appSnackBar(
            context,
            AppColor.green,
            toggleState.data.message?.isNotEmpty == true
                ? toggleState.data.message!
                : 'Promotional offer status updated successfully',
          );
          context.read<OffersListBloc>().add(const GetOffersListEvent(page: 1));
        } else if (toggleState is OfferStatusToggleFailureState) {
          appSnackBar(
            context,
            AppColor.bright_red,
            toggleState.message,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: OffersAddFabWidget(
        //   onTap: () {
        //     context.push(AppRoute.createOffer.path);
        //   },
        // ),
        body: Column(
          children: [
            // ── Top Curved Gradient Header ────────────────────────
            const OffersHeaderWidget(title: 'Offers'),

            // ── Offers List Content with Shimmer & Pagination ─────
            Expanded(
              child: BlocBuilder<OfferStatusToggleBloc, OfferStatusToggleState>(
                builder: (context, toggleState) {
                  final loadingOfferId =
                      toggleState is OfferStatusToggleLoadingState
                          ? toggleState.uuId
                          : null;

                  return OffersListViewWidget(
                    loadingOfferId: loadingOfferId,
                    onToggleOffer: (offer, nextStatus) {
                      if (offer.uuId != null && offer.uuId!.isNotEmpty) {
                        context.read<OfferStatusToggleBloc>().add(
                              ToggleOfferStatusEvent(
                                uuId: offer.uuId!,
                                isActive: nextStatus,
                              ),
                            );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
