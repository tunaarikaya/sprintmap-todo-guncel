import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

class StopwatchTimer extends StatefulWidget {
  const StopwatchTimer({super.key});

  @override
  State<StopwatchTimer> createState() => _StopwatchTimerState();
}

class _StopwatchTimerState extends State<StopwatchTimer> {
  Timer? _stopwatchTimer;
  Duration _stopwatchDuration = Duration.zero;
  bool _isStopwatchRunning = false;

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    super.dispose();
  }

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
    );
  }
} 