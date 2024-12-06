import 'package:task_manager/features/task/task_model.dart';

abstract interface class ITaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String taskId);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}
