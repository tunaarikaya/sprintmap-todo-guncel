import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class AddTodoDialog extends StatefulWidget {
  final Todo? todo;

  const AddTodoDialog({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TodoPriority _selectedPriority = TodoPriority.medium;
  DateTime? _selectedReminder;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
    if (widget.todo != null) {
      _selectedDate = widget.todo!.dueDate;
      _selectedPriority = widget.todo!.priority;
      _selectedReminder = widget.todo!.reminder;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDarkMode
          ? CupertinoColors.black
          : CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: isDarkMode
            ? CupertinoColors.black
            : CupertinoColors.systemBackground,
        middle: Text(
          isEditing ? 'Görevi Düzenle' : 'Yeni Görev',
          style: TextStyle(
            color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            'Vazgeç',
            style: TextStyle(
              fontSize: 17,
              color: isDarkMode
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemBlue,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            isEditing ? 'Kaydet' : 'Ekle',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemBlue,
            ),
          ),
          onPressed: () {
            if (_titleController.text.isEmpty) {
              _showErrorDialog(context, 'Lütfen bir başlık girin');
              return;
            }

            if (isEditing) {
              final updatedTodo = Todo(
                id: widget.todo!.id,
                title: _titleController.text,
                description: _descriptionController.text,
                dueDate: _selectedDate,
                isCompleted: widget.todo!.isCompleted,
                priority: _selectedPriority,
                reminder: _selectedReminder,
              );
              todoProvider.updateTodo(widget.todo!.id, updatedTodo);
            } else {
              final newTodo = Todo(
                title: _titleController.text,
                description: _descriptionController.text,
                dueDate: _selectedDate,
                priority: _selectedPriority,
                reminder: _selectedReminder,
              );
              todoProvider.addTodo(newTodo);
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CupertinoFormSection.insetGrouped(
                backgroundColor: isDarkMode
                    ? CupertinoColors.black
                    : CupertinoColors.systemGroupedBackground,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDarkMode
                      ? CupertinoColors.darkBackgroundGray
                      : CupertinoColors.white,
                ),
                header: const Padding(
                  padding: EdgeInsets.only(left: 20.0, bottom: 8.0),
                  child: Text(
                    'GÖREV BİLGİLERİ',
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: -0.08,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _titleController,
                    prefix: Text(
                      'Başlık',
                      style: TextStyle(
                        color: isDarkMode
                            ? CupertinoColors.white
                            : CupertinoColors.black,
                        fontSize: 17,
                      ),
                    ),
                    placeholder: 'Görev başlığını girin',
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? CupertinoColors.darkBackgroundGray
                          : CupertinoColors.white,
                    ),
                    style: TextStyle(
                      color: isDarkMode
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                      fontSize: 17,
                    ),
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _descriptionController,
                    prefix: Text(
                      'Açıklama',
                      style: TextStyle(
                        color: isDarkMode
                            ? CupertinoColors.white
                            : CupertinoColors.black,
                        fontSize: 17,
                      ),
                    ),
                    placeholder: 'Görev açıklamasını girin',
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    maxLines: 3,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? CupertinoColors.darkBackgroundGray
                          : CupertinoColors.white,
                    ),
                    style: TextStyle(
                      color: isDarkMode
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CupertinoFormSection.insetGrouped(
                backgroundColor: isDarkMode
                    ? CupertinoColors.black
                    : CupertinoColors.systemGroupedBackground,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDarkMode
                      ? CupertinoColors.darkBackgroundGray
                      : CupertinoColors.white,
                ),
                header: const Padding(
                  padding: EdgeInsets.only(left: 20.0, bottom: 8.0),
                  child: Text(
                    'DETAYLAR',
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: -0.08,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                children: [
                  _buildPrioritySelector(isDarkMode),
                  _buildDateSelector(isDarkMode),
                  _buildReminderSelector(isDarkMode),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(bool isDarkMode) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      prefix: Text(
        'Öncelik',
        style: TextStyle(
          color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
          fontSize: 17,
        ),
      ),
      child: CupertinoSlidingSegmentedControl<TodoPriority>(
        backgroundColor: isDarkMode
            ? CupertinoColors.systemGrey6.darkColor
            : CupertinoColors.systemGrey6,
        thumbColor: isDarkMode
            ? CupertinoColors.systemGrey5.darkColor
            : CupertinoColors.white,
        groupValue: _selectedPriority,
        children: {
          TodoPriority.low:
              _buildPrioritySegment('Düşük', TodoPriority.low, isDarkMode),
          TodoPriority.medium:
              _buildPrioritySegment('Orta', TodoPriority.medium, isDarkMode),
          TodoPriority.high:
              _buildPrioritySegment('Yüksek', TodoPriority.high, isDarkMode),
        },
        onValueChanged: (value) {
          if (value != null) setState(() => _selectedPriority = value);
        },
      ),
    );
  }

  Widget _buildPrioritySegment(
      String text, TodoPriority priority, bool isDarkMode) {
    Color textColor;
    switch (priority) {
      case TodoPriority.low:
        textColor = isDarkMode
            ? CupertinoColors.systemGreen
            : CupertinoColors.systemGreen;
        break;
      case TodoPriority.medium:
        textColor = isDarkMode
            ? CupertinoColors.systemOrange
            : CupertinoColors.systemOrange;
        break;
      case TodoPriority.high:
        textColor =
            isDarkMode ? CupertinoColors.systemRed : CupertinoColors.systemRed;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: _selectedPriority == priority
              ? textColor
              : (isDarkMode ? CupertinoColors.white : CupertinoColors.black),
          fontWeight: _selectedPriority == priority
              ? FontWeight.w600
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDateSelector(bool isDarkMode) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      prefix: Text(
        'Son Tarih',
        style: TextStyle(
          color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
          fontSize: 17,
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          _formatDate(_selectedDate),
          style: TextStyle(
            fontSize: 17,
            color: isDarkMode
                ? CupertinoColors.activeBlue
                : CupertinoColors.systemBlue,
          ),
        ),
        onPressed: () => _showDatePicker(context),
      ),
    );
  }

  Widget _buildReminderSelector(bool isDarkMode) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      prefix: Text(
        'Hatırlatıcı',
        style: TextStyle(
          color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
          fontSize: 17,
        ),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          _selectedReminder != null
              ? _formatDate(_selectedReminder!)
              : 'Hatırlatıcı Ekle',
          style: TextStyle(
            fontSize: 17,
            color: isDarkMode
                ? CupertinoColors.activeBlue
                : CupertinoColors.systemBlue,
          ),
        ),
        onPressed: () => _showReminderPicker(context),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Hata'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('Tamam'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('İptal'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Tamam'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate,
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: true,
                  minimumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() => _selectedDate = newDate);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReminderPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Kaldır'),
                    onPressed: () {
                      setState(() => _selectedReminder = null);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Tamam'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _selectedReminder ??
                      DateTime.now().add(const Duration(hours: 1)),
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: true,
                  minimumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() => _selectedReminder = newDate);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
