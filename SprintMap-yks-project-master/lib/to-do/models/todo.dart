import 'package:flutter/material.dart';

enum TodoPriority {
  low,
  medium,
  high,
}

class Todo {
  final String id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  TodoPriority priority;
  DateTime? reminder;
  DateTime createdAt;
  DateTime updatedAt;

  Todo({
    String? id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = TodoPriority.medium,
    this.reminder,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Color get priorityColor {
    switch (priority) {
      case TodoPriority.high:
        return Colors.red;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.low:
        return Colors.green;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'priority': priority.index,
      'reminder': reminder?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
      priority: TodoPriority.values[json['priority']],
      reminder:
          json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
    );
  }
}
