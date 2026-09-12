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
  bool _isMusicMuted = false;
  bool _isSfxMuted = false;

  bool get isMusicMuted => _isMusicMuted;
  bool get isSfxMuted => _isSfxMuted;

  GameAudioService() {
    // Allow all players (music + SFX) to play simultaneously.
    try {
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
    } catch (_) {}

    for (var i = 0; i < _sfxPoolSize; i++) {
      _sfxPool.add(AudioPlayer());
    }
  }

  // ── Mute Controls ──────────────────────────────────────────────────────────

  Future<void> setMusicMuted(bool muted) async {
    _isMusicMuted = muted;
    try {
      await _musicPlayer.setVolume(_isMusicMuted ? 0.0 : 1.0);
      if (!_isMusicMuted && _currentTrack != null) {
        if (_musicPlayer.state != PlayerState.playing) {
          await _musicPlayer.resume();
        }
      }
    } catch (_) {}
  }

  Future<void> toggleMusicMute() async {
    await setMusicMuted(!_isMusicMuted);
  }

  void setSfxMuted(bool muted) {
    _isSfxMuted = muted;
  }

  void toggleSfxMute() {
    _isSfxMuted = !_isSfxMuted;
  }

  // ── Ambient music ──────────────────────────────────────────────────────────

  Future<void> play(AmbientTrack track) async {
    if (_currentTrack == track) return; // already playing the right track

    _currentTrack = track;

    final asset = track == AmbientTrack.gameplay
        ? 'sound/gameplay.mp3'
        : 'sound/introandgameover.mp3';

    try {
      await _musicPlayer.stop();
      await _musicPlayer.setVolume(_isMusicMuted ? 0.0 : 1.0);
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.play(AssetSource(asset));
    } catch (_) {}
  }

  Future<void> stopMusic() async {
    _currentTrack = null;
    try {
      await _musicPlayer.stop();
    } catch (_) {}
  }

  // ── One-shot sound effects ─────────────────────────────────────────────────

  Future<void> playSfx(String assetPath) async {
    if (_isSfxMuted) return;

    try {
      // Round-robin through the pool so multiple sounds can overlap
      final player = _sfxPool[_sfxIndex % _sfxPoolSize];
      _sfxIndex++;
      await player.stop();
      await player.setReleaseMode(ReleaseMode.release);
      await player.play(AssetSource(assetPath));
    } catch (_) {}
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> dispose() async {
    try {
      await _musicPlayer.dispose();
      for (final p in _sfxPool) {
        await p.dispose();
      }
    } catch (_) {}
  }
}
