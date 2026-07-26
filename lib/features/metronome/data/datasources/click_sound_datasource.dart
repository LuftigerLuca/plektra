import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';

class ClickSoundDataSource {
  final SoLoud _soloud = SoLoud.instance;
  AudioSource? _accentSound;
  AudioSource? _normalSound;

  Future<void> init() async {
    if (!_soloud.isInitialized) {
      await _soloud.init();
    }

    _accentSound ??= await _soloud.loadAsset("assets/sounds/click_accent.wav");
    _normalSound ??= await _soloud.loadAsset("assets/sounds/click_normal.wav");
  }

  Future<void> playClick({required BeatMode mode}) async {
    if (mode == BeatMode.muted) return;
    final sound = mode == BeatMode.accent ? _accentSound : _normalSound;
    if (sound != null) {
      _soloud.play(sound);
    }
  }

  Future<void> dispose() async {
    if (_accentSound != null) await _soloud.disposeSource(_accentSound!);
    if (_normalSound != null) await _soloud.disposeSource(_normalSound!);
  }
}
