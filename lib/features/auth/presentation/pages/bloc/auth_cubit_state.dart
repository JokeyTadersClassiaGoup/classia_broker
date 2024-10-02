
import 'package:equatable/equatable.dart';

class AuthCubitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthSignUpLoadingState extends AuthCubitState {}

class AuthSignUpLoadedState extends AuthCubitState {}

class AuthSignUpErrorState extends AuthCubitState {
  final String message;

  AuthSignUpErrorState(this.message);
}

class AuthVerifyOtpLoadedState extends AuthCubitState {}

class AuthVerifyOtpErrorState extends AuthCubitState {
  final String message;

  AuthVerifyOtpErrorState(this.message);
}

class AuthLoginLoadedState extends AuthCubitState {}

class AuthLoginErrorState extends AuthCubitState {
  final String message;

  AuthLoginErrorState(this.message);
}
