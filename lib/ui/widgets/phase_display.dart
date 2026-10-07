import 'package:flutter/material.dart';

/// Exibe o rótulo animado da fase atual (ROUND N / INTERVALO / PRONTO).
class PhaseDisplay extends StatelessWidget {
  const PhaseDisplay({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 6,
        color: color,
      ),
      child: Text(label),
    );
  }
}
