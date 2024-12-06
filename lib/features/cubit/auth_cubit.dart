import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit_state.dart';
import 'package:flutter/widgets.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth,
        super(AuthCubitUnauthorized()) {
    _init();
  }

  void _init() {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthCubitAuthorized(user: user));
      } else {
        emit(AuthCubitUnauthorized());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthCubitLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthCubitAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthCubitUnauthorized(error: e));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthCubitLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthCubitAuthorized(user: userCredential.user!));
    } catch (e) {
      emit(AuthCubitUnauthorized(error: e));
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      emit(AuthCubitUnauthorized(error: e));
    }
  }

  static AuthCubit i(BuildContext context) => context.read<AuthCubit>();
}
