import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> with TickerProviderStateMixin {
  // YKS Tarihi (2024 YKS tarihi - 17-18 Haziran 2024)
  final DateTime yksDate = DateTime(2024, 6, 17);
  
  // YKS Geri Sayım değişkenleri
  Timer? _yksTimer;
  Duration _timeUntilYks = Duration.zero;
  
  // Kronometre değişkenleri
  Timer? _stopwatchTimer;
  Duration _stopwatchDuration = Duration.zero;
  bool _isStopwatchRunning = false;
  
  // Pomodoro değişkenleri
  Timer? _pomodoroTimer;
  Duration _pomodoroDuration = const Duration(minutes: 25); // Varsayılan 25 dakika
  final Duration _shortBreakDuration = const Duration(minutes: 5); // Varsayılan 5 dakika
  Duration _remainingPomodoroTime = const Duration(minutes: 25);
  bool _isPomodoroRunning = false;
  bool _isBreakTime = false;
  int _pomodoroCount = 0;
  
  // Animasyon kontrolcüleri
  late AnimationController _pomodoroProgressController;

  // Özel Sınav Sayacı değişkenleri
  final List<ExamCountdown> _examCountdowns = [];
  String _examName = '';
  DateTime? _examDate;
  String _selectedDateText = 'Tarih Seç';

  @override
  void initState() {
    super.initState();
    
    _pomodoroProgressController = AnimationController(
      vsync: this,
      duration: _pomodoroDuration,
    );

    _startYksCountdown();
  }

  @override
  void dispose() {
    _yksTimer?.cancel();
    _stopwatchTimer?.cancel();
    _pomodoroTimer?.cancel();
    _pomodoroProgressController.dispose();
    super.dispose();
  }

  // Kronometre metodları
  void _startStopwatch() {
    if (!mounted) return;
    
    setState(() {
      _isStopwatchRunning = true;
    });
    
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _stopwatchDuration += const Duration(seconds: 1);
      });
    });
  }

  void _pauseStopwatch() {
    if (!mounted) return;
    
    _stopwatchTimer?.cancel();
    setState(() {
      _isStopwatchRunning = false;
    });
  }

  void _resetStopwatch() {
    if (!mounted) return;
    
    _stopwatchTimer?.cancel();
    setState(() {
      _isStopwatchRunning = false;
      _stopwatchDuration = Duration.zero;
    });
  }

  // Pomodoro süre ayarlama metodu
  void _showPomodoroDurationPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 280,
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
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Tamam'),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _remainingPomodoroTime = _pomodoroDuration;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: _pomodoroDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    setState(() {
                      _pomodoroDuration = newDuration;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startYksCountdown() {
    _calculateTimeUntilYks();
    _yksTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _calculateTimeUntilYks();
      } else {
        timer.cancel();
      }
    });
  }

  void _calculateTimeUntilYks() {
    if (!mounted) return;
    
    final now = DateTime.now();
    setState(() {
      _timeUntilYks = yksDate.difference(now);
    });
  }

  // Pomodoro Metodları
  void _startPomodoro() {
    if (!mounted) return;
    
    setState(() {
      _isPomodoroRunning = true;
      if (_remainingPomodoroTime == Duration.zero) {
        _remainingPomodoroTime = _isBreakTime ? _shortBreakDuration : _pomodoroDuration;
      }
    });
    
    _pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (_remainingPomodoroTime > Duration.zero) {
          _remainingPomodoroTime -= const Duration(seconds: 1);
          _pomodoroProgressController.value = 
              1 - (_remainingPomodoroTime.inSeconds / 
                  (_isBreakTime ? _shortBreakDuration : _pomodoroDuration).inSeconds);
        } else {
          _pomodoroTimer?.cancel();
          _isPomodoroRunning = false;
          
          if (!_isBreakTime) {
            _pomodoroCount++;
            _showNotification(
              'Pomodoro tamamlandı!',
              'Şimdi 5 dakika mola verebilirsiniz.',
            );
          } else {
            _showNotification(
              'Mola bitti!',
              'Çalışmaya devam etme zamanı.',
            );
          }
          
          _isBreakTime = !_isBreakTime;
          _remainingPomodoroTime = _isBreakTime ? _shortBreakDuration : _pomodoroDuration;
          _pomodoroProgressController.reset();
        }
      });
    });
  }

  void _pausePomodoro() {
    if (!mounted) return;
    
    _pomodoroTimer?.cancel();
    setState(() {
      _isPomodoroRunning = false;
    });
  }

  void _resetPomodoro() {
    if (!mounted) return;
    
    _pomodoroTimer?.cancel();
    setState(() {
      _isPomodoroRunning = false;
      _isBreakTime = false;
      _remainingPomodoroTime = _pomodoroDuration;
      _pomodoroProgressController.reset();
    });
  }

  void _showNotification(String title, String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(message),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Tamam',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  // Özel Sınav Sayacı metodları
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
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
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
                            '${picked.day}/${picked.month}/${picked.year} ${time.format(context)}';
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

  Widget _buildExamCountdowns() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pomodoro Sayacı
              Card(
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
                                FontAwesomeIcons.stopwatch,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Pomodoro',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.trophy,
                                      color: AppTheme.primaryColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$_pomodoroCount',
                                      style: const TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.timer),
                                color: AppTheme.primaryColor,
                                onPressed: _showPomodoroDurationPicker,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor.withOpacity(0.1),
                              ),
                              child: CircularProgressIndicator(
                                value: 1 - (_remainingPomodoroTime.inSeconds /
                                    (_isBreakTime
                                        ? _shortBreakDuration.inSeconds
                                        : _pomodoroDuration.inSeconds)),
                                strokeWidth: 12,
                                backgroundColor: Colors.grey[200],
                                color: _isBreakTime
                                    ? AppTheme.accentColor
                                    : AppTheme.primaryColor,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatDuration(_remainingPomodoroTime),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: (_isBreakTime ? AppTheme.accentColor : AppTheme.primaryColor).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _isBreakTime ? 'Mola' : 'Çalışma',
                                    style: TextStyle(
                                      color: _isBreakTime
                                          ? AppTheme.accentColor
                                          : AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              _isPomodoroRunning ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            label: Text(
                              _isPomodoroRunning ? 'Duraklat' : 'Başlat',
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _isPomodoroRunning ? _pausePomodoro : _startPomodoro,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            color: AppTheme.primaryColor,
                            onPressed: _resetPomodoro,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Kronometre
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            CupertinoIcons.stopwatch,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Kronometre',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              _formatDuration(_stopwatchDuration),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(
                                    _isStopwatchRunning ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    _isStopwatchRunning ? 'Duraklat' : 'Başlat',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: _isStopwatchRunning ? _pauseStopwatch : _startStopwatch,
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  color: AppTheme.primaryColor,
                                  onPressed: _resetStopwatch,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // YKS Geri Sayım
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.graduationCap,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'YKS\'ye Kalan Süre',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTimeColumn(
                              _timeUntilYks.inDays.abs(),
                              'Gün',
                              AppTheme.primaryColor,
                            ),
                            _buildDivider(),
                            _buildTimeColumn(
                              _timeUntilYks.inHours.remainder(24).abs(),
                              'Saat',
                              AppTheme.secondaryColor,
                            ),
                            _buildDivider(),
                            _buildTimeColumn(
                              _timeUntilYks.inMinutes.remainder(60).abs(),
                              'Dakika',
                              AppTheme.accentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildExamCountdowns(),
            ],
          ),
        ),
      ),
    );
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
}

// Özel Sınav Sayacı sınıfı
class ExamCountdown {
  final String name;
  final DateTime date;

  ExamCountdown({
    required this.name,
    required this.date,
  });
}