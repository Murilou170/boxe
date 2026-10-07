import 'package:flutter/material.dart';

/// Indicador de round/intervalo exibido durante a execução.
/// Mostra nada quando [visible] é false.
class RoundIndicator extends StatelessWidget {
  const RoundIndicator({
    super.key,
    required this.visible,
    required this.label,
  });

  final bool visible;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF9E9E9E),
        letterSpacing: 1,
      ),
    );
  }
}
