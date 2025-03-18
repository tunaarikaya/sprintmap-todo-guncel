import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';


class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final String _storageKey = 'todos';

  List<Todo> get todos => _todos;
  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get incompleteTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();

  TodoProvider() {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_storageKey);
    if (todosJson != null) {
      final List<dynamic> decoded = jsonDecode(todosJson);
      _todos = decoded.map((item) => Todo.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    _saveTodos();
    notifyListeners();
  }

  void updateTodo(String id, Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      _saveTodos();
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    _saveTodos();
    notifyListeners();
  }

  void toggleTodoStatus(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      _saveTodos();
      notifyListeners();
    }
  }

  void reorderTodos(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Todo item = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, item);
    _saveTodos();
    notifyListeners();
  }

  List<Todo> getTodosByDate(DateTime date) {
    return _todos
        .where((todo) =>
            todo.dueDate.year == date.year &&
            todo.dueDate.month == date.month &&
            todo.dueDate.day == date.day)
        .toList();
  }

  List<Todo> filterByPriority(TodoPriority priority) {
    return _todos.where((todo) => todo.priority == priority).toList();
  }
}
