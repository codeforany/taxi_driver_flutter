part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitialState extends LoginState {}
final class LoginHUDState extends LoginState {}
final class LoginApiResultState extends LoginState {}
final class LoginErrorState extends LoginState {
  final  String errorMSG;
  const LoginErrorState(this.errorMSG);

  @override
  List<Object> get props => [];
}

