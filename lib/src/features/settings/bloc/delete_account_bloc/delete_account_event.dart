part of 'delete_account_bloc.dart';

sealed class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}

/// Event to permanently delete user account
class DeleteAccountSubmitEvent extends DeleteAccountEvent {}
