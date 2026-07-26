import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';

class MetronomeState {}

class MetronomeIdle extends MetronomeState {
  final BeatPattern pattern;
  MetronomeIdle({required this.pattern});
}

class MetronomeRunning extends MetronomeState {
  final BeatPattern pattern;
  final int currentBeat;
  final BeatMode currentMode;

  MetronomeRunning({
    required this.pattern,
    required this.currentBeat,
    required this.currentMode,
  });
}

class MetronomeError extends MetronomeState {
  final String message;
  MetronomeError(this.message);
}
