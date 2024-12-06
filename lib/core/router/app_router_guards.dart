import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/cubit/auth_cubit_state.dart';
import 'package:task_manager/features/cubit/auth_cubit.dart';
import 'package:task_manager/features/pages/sign_in_page.dart';
import 'package:task_manager/features/task/task_list_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouterGuards {
  static String? authorized(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthCubitAuthorized) {
      return SignInPage.path;
    }
    return null;
  }

  static String? unauthorized(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthCubitAuthorized) {
      return TaskListPage.path;
    }
    return null;
  }
}
