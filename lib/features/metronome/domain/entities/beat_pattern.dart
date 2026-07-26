import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';

class BeatPattern {
  final int bpm;
  final int beatsPerBar;
  final NoteValue noteValue;
  final Map<int, BeatMode> beatModes;

  const BeatPattern({
    required this.bpm,
    required this.beatsPerBar,
    this.noteValue = NoteValue.quarter,
    this.beatModes = const {},
  });

  BeatPattern copyWith({
    int? bpm,
    int? beatsPerBar,
    NoteValue? noteValue,
    Map<int, BeatMode>? beatModes,
  }) {
    return BeatPattern(
      bpm: bpm ?? this.bpm,
      beatsPerBar: beatsPerBar ?? this.beatsPerBar,
      noteValue: noteValue ?? this.noteValue,
      beatModes: beatModes ?? this.beatModes,
    );
  }
}
