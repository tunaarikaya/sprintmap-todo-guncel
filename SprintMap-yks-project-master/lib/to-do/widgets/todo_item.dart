import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import 'add_todo_dialog.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: CupertinoColors.systemRed,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          CupertinoIcons.delete,
          color: CupertinoColors.white,
        ),
      ),
      secondaryBackground: Container(
        color: CupertinoColors.systemRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          CupertinoIcons.delete,
          color: CupertinoColors.white,
        ),
      ),
      onDismissed: (_) {
        todoProvider.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${todo.title} silindi'),
            action: SnackBarAction(
              label: 'Geri Al',
              onPressed: () {
                todoProvider.addTodo(todo);
              },
            ),
            backgroundColor: CupertinoColors.darkBackgroundGray,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDarkMode
              ? CupertinoColors.darkBackgroundGray
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CupertinoListTile(
            backgroundColor: Colors.transparent,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                todo.isCompleted
                    ? CupertinoIcons.checkmark_circle_fill
                    : CupertinoIcons.circle,
                color: todo.isCompleted
                    ? CupertinoColors.activeGreen
                    : todo.priorityColor,
                size: 28,
              ),
              onPressed: () {
                todoProvider.toggleTodoStatus(todo.id);
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: todo.isCompleted
                              ? CupertinoColors.inactiveGray
                              : isDarkMode
                                  ? CupertinoColors.white
                                  : CupertinoColors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: todo.priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                if (todo.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    todo.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: todo.isCompleted
                          ? CupertinoColors.inactiveGray
                          : isDarkMode
                              ? CupertinoColors.lightBackgroundGray
                              : CupertinoColors.inactiveGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 14,
                      color: isDarkMode
                          ? CupertinoColors.lightBackgroundGray
                          : CupertinoColors.inactiveGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(todo.dueDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: todo.isCompleted
                            ? CupertinoColors.inactiveGray
                            : isDarkMode
                                ? CupertinoColors.lightBackgroundGray
                                : CupertinoColors.inactiveGray,
                      ),
                    ),
                    if (todo.reminder != null) ...[
                      const SizedBox(width: 12),
                      Icon(
                        CupertinoIcons.bell_fill,
                        size: 14,
                        color: isDarkMode
                            ? CupertinoColors.lightBackgroundGray
                            : CupertinoColors.inactiveGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(todo.reminder!),
                        style: TextStyle(
                          fontSize: 12,
                          color: todo.isCompleted
                              ? CupertinoColors.inactiveGray
                              : isDarkMode
                                  ? CupertinoColors.lightBackgroundGray
                                  : CupertinoColors.inactiveGray,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.pencil,
                color: CupertinoColors.activeBlue,
              ),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => AddTodoDialog(todo: todo),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
