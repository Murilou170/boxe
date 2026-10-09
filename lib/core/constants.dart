/// Duração de um round em segundos.
const int kRoundSeconds = 3 * 60;

/// Duração do intervalo em segundos.
const int kRestSeconds = 60;

/// Duração da contagem regressiva antes do primeiro round (segundos).
const int kCountdownSeconds = 3;

/// Segundos da contagem em que som_inicio_round é disparado (2 s antes de começar).
const int kCountdownBellSeconds = 2;

/// Segundos restantes no round em que o aviso sonoro (10seconds.mp3) é disparado.
/// Dispara com 12 s restantes para compensar a duração do áudio.
const int kWarnSeconds = 12;

/// Segundos restantes no round em que som_inicio_round é disparado (2 s antes de acabar).
const int kRoundEndBellSeconds = 2;

/// Segundos restantes no intervalo em que som_inicio_round é disparado (2 s antes de acabar).
const int kRestEndBellSeconds = 2;
