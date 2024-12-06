import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/pages/sign_in_page.dart';
import 'package:task_manager/features/pages/sign_up_page.dart';
import 'package:task_manager/features/task/task_list_page.dart' as task_list;
import 'package:task_manager/features/task/new_task_page.dart' as new_task;
import 'package:task_manager/features/task/task_list_cubit.dart';
import 'package:task_manager/features/task/task_repository.dart';
import 'package:task_manager/features/cubit/auth_cubit_state.dart';
import 'package:task_manager/features/pages/settings_page.dart';
import 'package:task_manager/features/cubit/auth_cubit.dart';
import 'package:task_manager/core/config.dart';
import 'app_router_key.dart';

class UnauthorizedException implements Exception {}

abstract final class AppRouter {
  static final router = GoRouter(
    navigatorKey: AppRouterKey.rootKey,
    initialLocation: SignInPage.path,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;

      if (authState is AuthCubitAuthorized &&
          (state.uri.path == SignInPage.path ||
              state.uri.path == SignUpPage.path)) {
        return '/tasks';
      }

      if (authState is! AuthCubitAuthorized &&
          state.uri.path != SignInPage.path &&
          state.uri.path != SignUpPage.path) {
        return SignInPage.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: SignInPage.path,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: SignUpPage.path,
        builder: (context, state) => const SignUpPage(),
      ),
      ShellRoute(
        navigatorKey: AppRouterKey.dashboardKey,
        builder: (context, state, child) => BlocProvider(
          create: (context) {
            final appConfiguration = AppConfiguration.i(context).state;
            final authState =
                context.read<AuthCubit>().state as AuthCubitAuthorized;
            final taskRepository = TaskRepository(
              firestore: appConfiguration.firestoreInstance,
              user: authState.user,
            );
            return TaskListCubit(taskRepository);
          },
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const task_list.TaskListPage(),
          ),
          GoRoute(
            path: '/new-task',
            builder: (context, state) => const new_task.NewTaskPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
