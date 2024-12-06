import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String userId;
  final DateTime dueDate;

  TaskModel({
    this.id = '',
    this.userId = '',
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? userId,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'userId': userId,
      'dueDate': DateTime(dueDate.year, dueDate.month, dueDate.day)
          .millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool,
      userId: map['userId'] as String,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
