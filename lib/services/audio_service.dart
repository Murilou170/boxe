import 'package:audioplayers/audioplayers.dart';

/// Encapsula a reprodução dos efeitos sonoros do timer.
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  /// Toca o gongo (início de round ou fim de round / início de intervalo).
  Future<void> playBell() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/bell.wav'));
  }

  /// Toca o aviso sonoro (10 segundos antes do fim do round).
  Future<void> playWarning() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/warning.wav'));
  }

  /// Para qualquer som em reprodução.
  Future<void> stop() => _player.stop();

  /// Libera recursos. Chamar em dispose.
  void dispose() => _player.dispose();
}
