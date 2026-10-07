import 'package:flutter/material.dart';

/// Botão circular que alterna entre INICIAR e PARAR.
class StartStopButton extends StatelessWidget {
  const StartStopButton({
    super.key,
    required this.running,
    required this.onTap,
  });

  final bool running;
  final VoidCallback onTap;

  static const Color _red = Color(0xFFE53935);
  static const Color _surface = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: running ? _surface : _red,
          border: Border.all(color: _red, width: 3),
        ),
        child: Center(
          child: Text(
            running ? 'PARAR' : 'INICIAR',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
              color: running ? _red : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
