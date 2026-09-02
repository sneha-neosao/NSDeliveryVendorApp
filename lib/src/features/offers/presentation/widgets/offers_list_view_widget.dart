import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_font.dart';
import '../../bloc/offers_list_bloc/offers_list_bloc.dart';
import '../../../../remote/models/offers_model/offers_list_response.dart';
import 'offer_card_widget.dart';
import 'offers_empty_state_widget.dart';
import 'offers_shimmer_widget.dart';

class OffersListViewWidget extends StatefulWidget {
  final String? loadingOfferId;
  final void Function(OfferItem offer, bool nextStatus)? onToggleOffer;

  const OffersListViewWidget({
    super.key,
    this.loadingOfferId,
    this.onToggleOffer,
  });

  @override
  State<OffersListViewWidget> createState() => _OffersListViewWidgetState();
}

class _OffersListViewWidgetState extends State<OffersListViewWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= (maxScroll - 200)) {
        context.read<OffersListBloc>().add(LoadMoreOffersListEvent());
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<OffersListBloc>().add(const GetOffersListEvent(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OffersListBloc, OffersListState>(
      builder: (context, state) {
        if (state is OffersListLoadingState) {
          return const OffersShimmerWidget();
        }

        if (state is OffersListFailureState) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.r,
                    color: AppColor.bright_red,
                  ),
                  14.hS,
                  Text(
                    state.message,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: AppFont.style(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.charcoal,
                    ),
                  ),
                  16.hS,
                  ElevatedButton.icon(
                    onPressed: _onRefresh,
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 16.r,
                      color: AppColor.pureWhite,
                    ),
                    label: Text(
                      'Retry',
                      style: AppFont.style(
                        color: AppColor.pureWhite,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is OffersListSuccessState) {
          if (state.items.isEmpty) {
            return RefreshIndicator(
              color: AppColor.primary,
              backgroundColor: AppColor.pureWhite,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: OffersEmptyStateWidget(
                    onRefresh: _onRefresh,
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColor.primary,
            backgroundColor: AppColor.pureWhite,
            onRefresh: _onRefresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 18.w,
                right: 18.w,
                top: 14.h,
                bottom: 16.h,
              ),
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => 14.hS,
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  );
                }

                final offer = state.items[index];
                final isOfferLoading = widget.loadingOfferId != null &&
                    widget.loadingOfferId == offer.uuId;

                return OfferCardWidget(
                  offer: offer,
                  isLoading: isOfferLoading,
                  onTap: () {
                    final nextStatus = !(offer.isActive ?? false);
                    widget.onToggleOffer?.call(offer, nextStatus);
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
