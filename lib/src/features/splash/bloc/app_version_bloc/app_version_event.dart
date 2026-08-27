part of 'app_version_bloc.dart';

sealed class AppVersionEvent extends Equatable {
  const AppVersionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch vendor app version details
class FetchAppVersionEvent extends AppVersionEvent {}
