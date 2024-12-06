import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppConfiguration extends Cubit<AppConfigurationState> {
  AppConfiguration()
      : super(
          AppConfigurationState(
            authInstance: FirebaseAuth.instance,
            firestoreInstance: FirebaseFirestore.instance,
          ),
        );

  static AppConfiguration i(BuildContext context) =>
      context.read<AppConfiguration>();
}

final class AppConfigurationState {
  final FirebaseAuth authInstance;
  final FirebaseFirestore firestoreInstance;

  AppConfigurationState({
    required this.authInstance,
    required this.firestoreInstance,
  });
}
