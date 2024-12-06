import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'task_list_cubit.dart';
import 'task_list_cubit_state.dart';
import 'task_list_item.dart';
import 'task_filter_widget.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  static const String path = '/tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мои задачи',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить список',
            onPressed: () => context.read<TaskListCubit>().loadTasks(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Настройки',
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/new-task'),
        label: const Text('Новая задача'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: TaskFilterWidget(),
          ),
          Expanded(
            child: BlocBuilder<TaskListCubit, TaskListCubitState>(
              builder: (context, state) {
                if (state is TaskListStateLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                  );
                }

                if (state is TaskListStateSuccess) {
                  if (state.taskList.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt, color: Colors.grey, size: 48),
                          SizedBox(height: 16),
                          Text(
                            'У вас нет задач для выбранного фильтра',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.taskList.length,
                    separatorBuilder: (_, __) => const Divider(
                      thickness: 1,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final task = state.taskList[index];
                      return Dismissible(
                        key: Key(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) =>
                            context.read<TaskListCubit>().removeTask(task),
                        child: TaskCard(
                          task: task,
                          onCompleteStatusChanged: () => context
                              .read<TaskListCubit>()
                              .changeCompleteStatusTask(task),
                          onRemoveTask: () =>
                              context.read<TaskListCubit>().removeTask(task),
                        ),
                      );
                    },
                  );
                }

                if (state is TaskListStateFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Ошибка: ${state.error}',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
