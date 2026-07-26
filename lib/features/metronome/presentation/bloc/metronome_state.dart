import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';

class MetronomeState {}

class MetronomeIdle extends MetronomeState {
  final BeatPattern pattern;
  MetronomeIdle({required this.pattern});
}

class MetronomeRunning extends MetronomeState {
  final int currentBeat;
  final bool isAccented;
  final int bpm;
  final int beatsPerBar;
  final NoteValue noteValue;

  MetronomeRunning({
    required this.currentBeat,
    required this.isAccented,
    required this.bpm,
    required this.beatsPerBar,
    required this.noteValue,
  });
}

class MetronomeError extends MetronomeState {
  final String message;
  MetronomeError(this.message);
}