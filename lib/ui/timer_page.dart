import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../core/constants.dart';
import '../core/timer_phase.dart';
import '../services/audio_service.dart';
import '../services/foreground_service.dart';
import 'widgets/phase_display.dart';
import 'widgets/round_indicator.dart';
import 'widgets/start_stop_button.dart';
import 'widgets/time_display.dart';

class BoxeTimerPage extends StatefulWidget {
  const BoxeTimerPage({super.key});

  @override
  State<BoxeTimerPage> createState() => _BoxeTimerPageState();
}

class _BoxeTimerPageState extends State<BoxeTimerPage>
    with WidgetsBindingObserver {
  // ── Estado ───────────────────────────────────────────────────────────────────
  TimerPhase _phase = TimerPhase.idle;
  int _roundNumber = 0;
  int _secondsLeft = kRoundSeconds;

  /// Timestamp absoluto do momento em que a fase atual termina.
  DateTime? _phaseEndsAt;

  /// Evita disparar o aviso mais de uma vez na mesma fase.
  bool _warnFired = false;

  Timer? _ticker;

  // ── Serviços ─────────────────────────────────────────────────────────────────
  final AudioService _audio = AudioService();

  // ── Lifecycle ─────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _audio.dispose();
    super.dispose();
  }

  /// Ao voltar ao foreground, recalcula o estado imediatamente sem esperar
  /// o próximo tick do timer.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _phase != TimerPhase.idle) {
      _tick();
    }
  }

  // ── Controles ─────────────────────────────────────────────────────────────────

  Future<void> _start() async {
    await ForegroundService.requestPermission();
    await WakelockPlus.enable();
    await ForegroundService.start('Round 1 em andamento');

    _roundNumber = 1;
    _warnFired = false;
    _phase = TimerPhase.round;
    _phaseEndsAt = DateTime.now().add(const Duration(seconds: kRoundSeconds));
    _secondsLeft = kRoundSeconds;

    if (mounted) setState(() {});

    await _audio.playBell();
    _startTicker();
  }

  void _stop() {
    _ticker?.cancel();
    _ticker = null;
    _audio.stop();
    WakelockPlus.disable();
    ForegroundService.stop();

    setState(() {
      _phase = TimerPhase.idle;
      _roundNumber = 0;
      _secondsLeft = kRoundSeconds;
      _phaseEndsAt = null;
      _warnFired = false;
    });
  }

  // ── Ticker ────────────────────────────────────────────────────────────────────

  void _startTicker() {
    _ticker?.cancel();
    // 250 ms: mantém a UI responsiva e garante que eventos sonoros
    // não sejam perdidos por imprecisão de um tick de 1 s.
    _ticker = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => _tick(),
    );
  }

  void _tick() {
    if (_phase == TimerPhase.idle || _phaseEndsAt == null) return;

    final remaining = _phaseEndsAt!.difference(DateTime.now());
    final secs = remaining.inSeconds.clamp(0, 9999);

    // Aviso de 10 segundos (apenas durante rounds).
    if (_phase == TimerPhase.round && secs <= kWarnSeconds && !_warnFired) {
      _warnFired = true;
      _audio.playWarning();
    }

    // Transição de fase ao zerar.
    if (remaining.isNegative || remaining == Duration.zero) {
      if (_phase == TimerPhase.round) {
        _transitionToRest();
      } else {
        _transitionToRound();
      }
      return;
    }

    if (mounted) setState(() => _secondsLeft = secs);
  }

  void _transitionToRest() {
    _warnFired = false;
    _phase = TimerPhase.rest;
    _phaseEndsAt = DateTime.now().add(const Duration(seconds: kRestSeconds));
    _secondsLeft = kRestSeconds;
    if (mounted) setState(() {});
    _audio.playBell();
    ForegroundService.updateNotification('Intervalo $_roundNumber — Descanse!');
  }

  void _transitionToRound() {
    _roundNumber++;
    _warnFired = false;
    _phase = TimerPhase.round;
    _phaseEndsAt = DateTime.now().add(const Duration(seconds: kRoundSeconds));
    _secondsLeft = kRoundSeconds;
    if (mounted) setState(() {});
    _audio.playBell();
    ForegroundService.updateNotification('Round $_roundNumber');
  }

  // ── Helpers de UI ─────────────────────────────────────────────────────────────

  Color get _phaseColor {
    switch (_phase) {
      case TimerPhase.round:
        return const Color(0xFFE53935);
      case TimerPhase.rest:
        return const Color(0xFF43A047);
      case TimerPhase.idle:
        return const Color(0xFF616161);
    }
  }

  String get _phaseLabel {
    switch (_phase) {
      case TimerPhase.round:
        return 'ROUND $_roundNumber';
      case TimerPhase.rest:
        return 'INTERVALO';
      case TimerPhase.idle:
        return 'PRONTO';
    }
  }

  String get _roundIndicatorLabel {
    if (_phase == TimerPhase.rest) return 'Próximo: Round ${_roundNumber + 1}';
    return 'Round $_roundNumber';
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool running = _phase != TimerPhase.idle;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhaseDisplay(label: _phaseLabel, color: _phaseColor),

              const SizedBox(height: 32),

              TimeDisplay(secondsLeft: _secondsLeft, color: _phaseColor),

              const SizedBox(height: 48),

              RoundIndicator(
                visible: running,
                label: _roundIndicatorLabel,
              ),

              const SizedBox(height: 48),

              StartStopButton(
                running: running,
                onTap: running ? _stop : _start,
              ),

              const SizedBox(height: 32),

              const Text(
                'Round: 3:00   |   Intervalo: 1:00',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF616161),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
