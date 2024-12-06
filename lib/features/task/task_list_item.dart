import 'package:flutter/material.dart';
import 'package:task_manager/features/task/task_model.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onCompleteStatusChanged;
  final VoidCallback onRemoveTask;

  const TaskCard({
    super.key,
    required this.task,
    required this.onCompleteStatusChanged,
    required this.onRemoveTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onCompleteStatusChanged(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(task.description),
                  const SizedBox(height: 8),
                  Text(
                    'Срок: ${DateFormat('d MMMM y', 'ru').format(task.dueDate)}',
                    style: TextStyle(
                      color: task.dueDate.isBefore(DateTime.now()) &&
                              !task.isCompleted
                          ? Colors.red
                          : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemoveTask,
            ),
          ],
        ),
      ),
    );
  }
}
