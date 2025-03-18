import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  TodoPriority? _selectedPriority;
  bool _showCompleted = true;
  final String _storageKey = 'todos';

  List<Todo> get todos {
    var filteredList = List<Todo>.from(_todos);

    if (_selectedPriority != null) {
      filteredList = filteredList
          .where((todo) => todo.priority == _selectedPriority)
          .toList();
    }

    if (!_showCompleted) {
      filteredList = filteredList.where((todo) => !todo.isCompleted).toList();
    }

    filteredList.sort((a, b) {
      // Önce tamamlanmamış görevler
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Sonra önceliğe göre
      if (a.priority != b.priority) {
        return a.priority.index.compareTo(b.priority.index);
      }
      // Son olarak tarihe göre
      return a.dueDate.compareTo(b.dueDate);
    });

    return filteredList;
  }

  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get incompleteTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();

  bool get showCompleted => _showCompleted;
  TodoPriority? get selectedPriority => _selectedPriority;

  TodoProvider() {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todosJson = prefs.getString(_storageKey);
      if (todosJson != null) {
        final List<dynamic> decoded = jsonDecode(todosJson);
        _todos = decoded.map((item) => Todo.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Görevler yüklenirken hata oluştu: $e');
    }
  }

  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded =
          jsonEncode(_todos.map((todo) => todo.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Görevler kaydedilirken hata oluştu: $e');
    }
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
    final List<Todo> currentList = todos;
    final Todo item = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, item);

    // Ana listedeki sıralamayı güncelle
    final List<String> newOrder = currentList.map((todo) => todo.id).toList();
    _todos.sort(
        (a, b) => newOrder.indexOf(a.id).compareTo(newOrder.indexOf(b.id)));

    _saveTodos();
    notifyListeners();
  }

  List<Todo> getTodosByDate(DateTime date) {
    return _todos.where((todo) {
      final todoDate =
          DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
      final compareDate = DateTime(date.year, date.month, date.day);
      return todoDate.isAtSameMomentAs(compareDate);
    }).toList();
  }

  void filterByPriority(TodoPriority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void toggleShowCompleted() {
    _showCompleted = !_showCompleted;
    notifyListeners();
  }

  void clearCompletedTodos() {
    _todos.removeWhere((todo) => todo.isCompleted);
    _saveTodos();
    notifyListeners();
  }

  int get totalTodos => _todos.length;
  int get completedCount => completedTodos.length;
  double get completionRate =>
      totalTodos == 0 ? 0 : (completedCount / totalTodos * 100);
}
