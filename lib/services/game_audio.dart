import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class GameAudio {
  static final AudioPlayer _bgmPlayer = AudioPlayer(playerId: 'bgm_player');
  static final AudioPlayer _sfxPlayer = AudioPlayer(playerId: 'sfx_player');

  static bool _isInitialized = false;
  static bool _isMusicEnabled = true;
  static bool _isSoundEnabled = true;
  static bool _isBgmPlaying = false;

  static bool get isMusicEnabled => _isMusicEnabled;
  static bool get isSoundEnabled => _isSoundEnabled;
  static bool get isBgmPlaying => _isBgmPlaying;

  static final AudioContext _audioContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
    stayAwake: true,
  ).build();

  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _bgmPlayer.setAudioContext(_audioContext);
      await _sfxPlayer.setAudioContext(_audioContext);

      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);

      await _bgmPlayer.setVolume(0.40);
      await _sfxPlayer.setVolume(0.90);

      _isInitialized = true;
    } catch (e) {
      debugPrint('GameAudio init error: $e');
    }
  }

  static Future<void> playBgm() async {
    await init();

    if (!_isMusicEnabled) return;
    if (_isBgmPlaying) return;

    try {
      await _bgmPlayer.play(
        AssetSource('audio/bgm.mp3'),
        ctx: _audioContext,
        mode: PlayerMode.mediaPlayer,
      );

      _isBgmPlaying = true;
    } catch (e) {
      debugPrint('Play BGM error: $e');
    }
  }

  static Future<void> pauseBgm() async {
    try {
      await _bgmPlayer.pause();
      _isBgmPlaying = false;
    } catch (e) {
      debugPrint('Pause BGM error: $e');
    }
  }

  static Future<void> resumeBgm() async {
    await init();

    if (!_isMusicEnabled) return;
    if (_isBgmPlaying) return;

    try {
      await _bgmPlayer.resume();
      _isBgmPlaying = true;
    } catch (e) {
      debugPrint('Resume BGM error: $e');
    }
  }

  static Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
      _isBgmPlaying = false;
    } catch (e) {
      debugPrint('Stop BGM error: $e');
    }
  }

  static Future<void> playClick() async {
    await init();

    if (!_isSoundEnabled) return;

    try {
      await _sfxPlayer.stop();

      await _sfxPlayer.play(
        AssetSource('audio/click.mp3'),
        ctx: _audioContext,
        mode: PlayerMode.lowLatency,
        volume: 0.90,
      );
    } catch (e) {
      debugPrint('Play click sound error: $e');
    }
  }

  static Future<void> setMusicEnabled(bool value) async {
    _isMusicEnabled = value;

    if (_isMusicEnabled) {
      await playBgm();
    } else {
      await pauseBgm();
    }
  }

  static Future<void> setSoundEnabled(bool value) async {
    _isSoundEnabled = value;
  }

  static Future<bool> toggleMusic() async {
    _isMusicEnabled = !_isMusicEnabled;

    if (_isMusicEnabled) {
      await playBgm();
    } else {
      await pauseBgm();
    }

    return _isMusicEnabled;
  }

  static Future<bool> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    return _isSoundEnabled;
  }

  static Future<void> setBgmVolume(double volume) async {
    final double safeVolume = volume.clamp(0.0, 1.0);

    try {
      await _bgmPlayer.setVolume(safeVolume);
    } catch (e) {
      debugPrint('Set BGM volume error: $e');
    }
  }

  static Future<void> setSfxVolume(double volume) async {
    final double safeVolume = volume.clamp(0.0, 1.0);

    try {
      await _sfxPlayer.setVolume(safeVolume);
    } catch (e) {
      debugPrint('Set SFX volume error: $e');
    }
  }

  static Future<void> dispose() async {
    try {
      await _bgmPlayer.dispose();
      await _sfxPlayer.dispose();

      _isInitialized = false;
      _isBgmPlaying = false;
    } catch (e) {
      debugPrint('Dispose GameAudio error: $e');
    }
  }
}