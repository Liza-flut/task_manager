import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/features/cubit/auth_cubit.dart';
import 'package:task_manager/features/cubit/auth_cubit_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String path = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tasks'),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<AuthCubit, AuthCubitState>(
        builder: (context, state) {
          if (state is AuthCubitAuthorized) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading:
                          const Icon(Icons.person, color: Colors.deepPurple),
                      title: const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        state.user.email ?? 'Нет email',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.verified, color: Colors.green),
                      title: Text(
                        'Статус аккаунта',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Верифицирован',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1.5),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Выйти',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      onTap: AuthCubit.i(context).signOut,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
