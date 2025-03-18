import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> with TickerProviderStateMixin {
  Timer? _pomodoroTimer;
  Duration _pomodoroDuration = const Duration(minutes: 25);
  final Duration _shortBreakDuration = const Duration(minutes: 5);
  Duration _remainingPomodoroTime = const Duration(minutes: 25);
  bool _isPomodoroRunning = false;
  bool _isBreakTime = false;
  int _pomodoroCount = 0;
  
  late AnimationController _pomodoroProgressController;

  @override
  void initState() {
    super.initState();
    _pomodoroProgressController = AnimationController(
      vsync: this,
      duration: _pomodoroDuration,
    );
  }

  @override
  void dispose() {
    _pomodoroTimer?.cancel();
    _pomodoroProgressController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
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
    );
  }
} 