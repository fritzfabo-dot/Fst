import 'package:audioplayers/audioplayers.dart';

enum AmbientTrack { menuAndGameOver, gameplay }

class GameAudioService {
  // Dedicated player for looping ambient music
  final AudioPlayer _musicPlayer = AudioPlayer();

  // Pool of players for overlapping one-shot sound effects
  static const int _sfxPoolSize = 6;
  final List<AudioPlayer> _sfxPool = [];
  int _sfxIndex = 0;

  AmbientTrack? _currentTrack;

  GameAudioService() {
    // Allow all players (music + SFX) to play simultaneously.
    // Without this, each new play() call grabs exclusive audio focus,
    // which silences any already-playing player.
    AudioPlayer.global.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
        android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.game,
          audioFocus: AndroidAudioFocus.none,
        ),
      ),
    );

    for (var i = 0; i < _sfxPoolSize; i++) {
      _sfxPool.add(AudioPlayer());
    }
  }

  // ── Ambient music ──────────────────────────────────────────────────────────

  Future<void> play(AmbientTrack track) async {
    if (_currentTrack == track) return; // already playing the right track

    _currentTrack = track;

    final asset = track == AmbientTrack.gameplay
        ? 'sound/gameplay.mp3'
        : 'sound/introandgameover.mp3';

    await _musicPlayer.stop();
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.play(AssetSource(asset));
  }

  Future<void> stopMusic() async {
    _currentTrack = null;
    await _musicPlayer.stop();
  }

  // ── One-shot sound effects ─────────────────────────────────────────────────

  Future<void> playSfx(String assetPath) async {
    // Round-robin through the pool so multiple sounds can overlap
    final player = _sfxPool[_sfxIndex % _sfxPoolSize];
    _sfxIndex++;
    await player.stop();
    await player.setReleaseMode(ReleaseMode.release);
    await player.play(AssetSource(assetPath));
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> dispose() async {
    await _musicPlayer.dispose();
    for (final p in _sfxPool) {
      await p.dispose();
    }
  }
}
