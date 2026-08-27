part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

/// Event to submit forgot password request with email
class SubmitForgotPasswordEvent extends ForgotPasswordEvent {
  final String email;

  const SubmitForgotPasswordEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}
