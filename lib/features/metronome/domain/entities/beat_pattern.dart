import 'package:plektra/features/metronome/domain/entities/note_value.dart';

class BeatPattern {
  final int bpm;
  final int beatsPerBar;
  final NoteValue noteValue;

  const BeatPattern({required this.bpm, required this.beatsPerBar, this.noteValue = NoteValue.quarter});

  BeatPattern copyWith({int? bpm, int? beatsPerBar, NoteValue? noteValue}) {
    return BeatPattern(
      bpm: bpm ?? this.bpm,
      beatsPerBar: beatsPerBar ?? this.beatsPerBar,
      noteValue: noteValue ?? this.noteValue,
    );
  }
}