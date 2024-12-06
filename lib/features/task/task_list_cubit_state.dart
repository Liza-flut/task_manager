import 'package:task_manager/features/task/task_model.dart';

abstract class TaskListCubitState {}

class TaskListStateLoading extends TaskListCubitState {}

class TaskListStateSuccess extends TaskListCubitState {
  final List<TaskModel> taskList;
  final TaskFilter filter;

  TaskListStateSuccess({
    required this.taskList,
    required this.filter,
  });
}

class TaskListStateFailure extends TaskListCubitState {
  final Object error;

  TaskListStateFailure({required this.error});
}

enum TaskFilter { all, active, completed }
