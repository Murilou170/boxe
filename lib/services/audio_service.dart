import 'package:audioplayers/audioplayers.dart';

/// Encapsula a reprodução dos efeitos sonoros do timer.
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  /// Toca o som de início/fim de round (som_inicio_round.mp3).
  Future<void> playRoundBell() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/som_inicio_round.mp3'));
  }

  /// Toca o aviso de 10 segundos (10seconds.mp3) no volume máximo.
  Future<void> playWarning() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/10seconds.mp3'), volume: 1.0);
  }

  /// Para qualquer som em reprodução.
  Future<void> stop() => _player.stop();

  /// Libera recursos. Chamar em dispose.
  void dispose() => _player.dispose();
}
