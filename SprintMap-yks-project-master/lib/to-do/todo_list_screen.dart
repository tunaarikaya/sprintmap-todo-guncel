import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'models/todo.dart';
import 'widgets/todo_item.dart';
import 'widgets/add_todo_dialog.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text(''),
            backgroundColor:
                isDarkMode ? CupertinoColors.black : CupertinoColors.systemBlue,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.calendar,
                    color: CupertinoColors.white,
                  ),
                  onPressed: () {
                    // Takvim sayfasına yönlendirme
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: CupertinoColors.white,
                  ),
                  onPressed: () {
                    _showFilterActionSheet(context, todoProvider);
                  },
                ),
              ],
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                child: todoProvider.todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.check_mark_circled,
                              size: 100,
                              color: isDarkMode
                                  ? CupertinoColors.systemGrey
                                  : CupertinoColors.systemGrey2,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Henüz yapılacak bir şey yok',
                              style: TextStyle(
                                fontSize: 18,
                                color: isDarkMode
                                    ? CupertinoColors.systemGrey
                                    : CupertinoColors.systemGrey2,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: todoProvider.todos.length,
                        onReorder: todoProvider.reorderTodos,
                        itemBuilder: (context, index) {
                          final todo = todoProvider.todos[index];
                          return TodoItem(
                            key: Key(todo.id),
                            todo: todo,
                          );
                        },
                      ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: GestureDetector(
                  onTap: () => _showAddTodoDialog(context),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.add,
                      color: CupertinoColors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isDarkMode
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.systemBackground,
        );
      },
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }

  void _showFilterActionSheet(BuildContext context, TodoProvider todoProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Önceliğe Göre Filtrele'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Yüksek Öncelik'),
            onPressed: () {
              todoProvider.filterByPriority(TodoPriority.high);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Orta Öncelik'),
            onPressed: () {
              todoProvider.filterByPriority(TodoPriority.medium);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Düşük Öncelik'),
            onPressed: () {
              todoProvider.filterByPriority(TodoPriority.low);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Tümünü Göster'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('İptal'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
