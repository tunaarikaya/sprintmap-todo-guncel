import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprintmap/to-do/providers/todo_provider.dart';
import 'package:sprintmap/to-do/todo_list_screen.dart';

class ToDoView extends StatelessWidget {
  const ToDoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: const TodoListScreen(),
    );
  }
}
