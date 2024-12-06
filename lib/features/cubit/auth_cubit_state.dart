import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthCubitState {}

class AuthCubitUnauthorized extends AuthCubitState {
  final Object? error;

  AuthCubitUnauthorized({this.error});
}

class AuthCubitAuthorized extends AuthCubitState {
  final User user;

  AuthCubitAuthorized({required this.user});
}

class AuthCubitLoading extends AuthCubitState {}
