import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintmap/theme/app_theme.dart';

class YksCountdown extends StatefulWidget {
  const YksCountdown({super.key});

  @override
  State<YksCountdown> createState() => _YksCountdownState();
}

class _YksCountdownState extends State<YksCountdown> {
  final DateTime yksDate = DateTime(2024, 6, 17);
  Timer? _yksTimer;
  Duration _timeUntilYks = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startYksCountdown();
  }

  @override
  void dispose() {
    _yksTimer?.cancel();
    super.dispose();
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
    );
  }
} 