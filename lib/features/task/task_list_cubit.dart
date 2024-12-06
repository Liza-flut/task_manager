import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/task_model.dart';
import 'package:task_manager/features/task/task_repository_interface.dart';
import 'package:task_manager/features/task/task_list_cubit_state.dart';

class TaskListCubit extends Cubit<TaskListCubitState> {
  final ITaskRepository _taskRepository;
  TaskFilter _currentFilter = TaskFilter.all;

  TaskListCubit(this._taskRepository) : super(TaskListStateLoading()) {
    loadTasks();
  }

  TaskFilter get currentFilter => _currentFilter;

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    loadTasks(withReload: false);
  }

  Future<void> loadTasks({bool withReload = true}) async {
    if (withReload) emit(TaskListStateLoading());
    try {
      final taskList = await _taskRepository.getTasks();
      final filteredAndSortedTasks = _processTaskList(taskList);
      emit(TaskListStateSuccess(
        taskList: filteredAndSortedTasks,
        filter: _currentFilter,
      ));
    } catch (e) {
      emit(TaskListStateFailure(error: e));
    }
  }

  List<TaskModel> _processTaskList(List<TaskModel> tasks) {
    final filteredTasks = _filterTasks(tasks);
    return _sortTasks(filteredTasks);
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    switch (_currentFilter) {
      case TaskFilter.active:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      default:
        return tasks;
    }
  }

  List<TaskModel> _sortTasks(List<TaskModel> tasks) {
    return tasks
      ..sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return a.dueDate.compareTo(b.dueDate);
      });
  }

  Future<void> createTask(TaskModel task) async {
    emit(TaskListStateLoading());
    try {
      await _taskRepository.addTask(task);
      await loadTasks(withReload: false);
    } catch (e) {
      emit(TaskListStateFailure(error: e));
    }
  }

  Future<void> removeTask(TaskModel task) async {
    try {
      await _taskRepository.deleteTask(task.id);
      await loadTasks(withReload: false);
    } catch (e) {
      emit(TaskListStateFailure(error: e));
    }
  }

  Future<void> changeCompleteStatusTask(TaskModel task) async {
    try {
      emit(TaskListStateLoading());
      await _taskRepository.updateTask(
        task.copyWith(isCompleted: !task.isCompleted),
      );
      await loadTasks(withReload: false);
    } catch (e) {
      emit(TaskListStateFailure(error: e));
    }
  }
}
