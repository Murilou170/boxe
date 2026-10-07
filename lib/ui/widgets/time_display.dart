import 'package:flutter/material.dart';

/// Container com o tempo restante formatado em MM:SS.
class TimeDisplay extends StatelessWidget {
  const TimeDisplay({
    super.key,
    required this.secondsLeft,
    required this.color,
  });

  final int secondsLeft;
  final Color color;

  String _format(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          _format(secondsLeft),
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w300,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: color,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}
