import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';

abstract class MetronomeEvent {}

class MetronomeStarted extends MetronomeEvent {
  final BeatPattern pattern;
  MetronomeStarted(this.pattern);
}

class MetronomeStopped extends MetronomeEvent {}

class MetronomeBpmChanged extends MetronomeEvent {
  final int bpm;
  MetronomeBpmChanged(this.bpm);
}

class MetronomePatternChanged extends MetronomeEvent {
  final BeatPattern pattern;
  MetronomePatternChanged(this.pattern);
}

class MetronomeNoteValueChanged extends MetronomeEvent {
  final NoteValue noteValue;
  MetronomeNoteValueChanged(this.noteValue);
}

class MetronomeBeatModeChanged extends MetronomeEvent {
  final int beatNumber;
  final BeatMode mode;
  MetronomeBeatModeChanged(this.beatNumber, this.mode);
}
