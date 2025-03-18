import 'package:flutter/material.dart';
import 'package:sprintmap/features/counter/widgets/pomodoro_timer.dart';
import 'package:sprintmap/features/counter/widgets/stopwatch_timer.dart';
import 'package:sprintmap/features/counter/widgets/yks_countdown.dart';
import 'package:sprintmap/features/counter/widgets/exam_countdown_list.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PomodoroTimer(),
              SizedBox(height: 24),
              StopwatchTimer(),
              SizedBox(height: 24),
              YksCountdown(),
              SizedBox(height: 24),
              ExamCountdownList(),
            ],
          ),
        ),
      ),
    );
  }
} 