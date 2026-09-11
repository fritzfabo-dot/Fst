import 'package:audioplayers/audioplayers.dart';

enum AmbientTrack { menuAndGameOver, gameplay }

class GameAudioService {
  final AudioPlayer _player = AudioPlayer();

  AmbientTrack? _currentTrack;

  Future<void> play(AmbientTrack track) async {
    if (_currentTrack == track) return; // already playing the right track

    _currentTrack = track;

    final asset = track == AmbientTrack.gameplay
        ? 'sound/gameplay.mp3'
        : 'sound/introandgameover.mp3';

    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource(asset));
  }

  Future<void> stop() async {
    _currentTrack = null;
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
