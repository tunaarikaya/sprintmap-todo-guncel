import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:sprintmap/features/counter/models/exam_countdown.dart';

class ExamCountdownList extends StatefulWidget {
  const ExamCountdownList({super.key});

  @override
  State<ExamCountdownList> createState() => _ExamCountdownListState();
}

class _ExamCountdownListState extends State<ExamCountdownList> {
  final List<ExamCountdown> _examCountdowns = [];
  String _examName = '';
  DateTime? _examDate;
  String _selectedDateText = 'Tarih Seç';

  void _addNewExam() {
    _examName = '';
    _examDate = null;
    _selectedDateText = 'Tarih Seç';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Yeni Sınav Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Sınav Adı',
                  hintText: 'Örn: TYT Denemesi',
                ),
                onChanged: (value) {
                  setState(() => _examName = value);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDateText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final now = DateTime.now();
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: DateTime(2025, 12, 31),
                    locale: const Locale('tr', 'TR'),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppTheme.primaryColor,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  
                  if (picked != null) {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppTheme.primaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    
                    if (time != null) {
                      setState(() {
                        _examDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time.hour,
                          time.minute,
                        );
                        _selectedDateText = 
                            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year} ${time.format(context)}';
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                _examName = '';
                _examDate = null;
                _selectedDateText = 'Tarih Seç';
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ekle'),
              onPressed: () {
                if (_examName.isNotEmpty && _examDate != null) {
                  this.setState(() {
                    _examCountdowns.add(
                      ExamCountdown(
                        name: _examName,
                        date: _examDate!,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  _examName = '';
                  _examDate = null;
                  _selectedDateText = 'Tarih Seç';
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen sınav adı ve tarihini giriniz'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeExam(int index) {
    setState(() {
      _examCountdowns.removeAt(index);
    });
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildTimeColumn(int value, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_examCountdowns.isEmpty) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.clipboardList,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Sınavlarım',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: AppTheme.primaryColor,
                    onPressed: _addNewExam,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Henüz sınav eklenmemiş',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.clipboardList,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Sınavlarım',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: AppTheme.primaryColor,
                  onPressed: _addNewExam,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _examCountdowns.length,
              itemBuilder: (context, index) {
                final exam = _examCountdowns[index];
                final timeUntilExam = exam.date.difference(DateTime.now());
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              exam.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () => _removeExam(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTimeColumn(
                              timeUntilExam.inDays.abs(),
                              'Gün',
                              AppTheme.primaryColor,
                            ),
                            _buildDivider(),
                            _buildTimeColumn(
                              timeUntilExam.inHours.remainder(24).abs(),
                              'Saat',
                              AppTheme.secondaryColor,
                            ),
                            _buildDivider(),
                            _buildTimeColumn(
                              timeUntilExam.inMinutes.remainder(60).abs(),
                              'Dakika',
                              AppTheme.accentColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 