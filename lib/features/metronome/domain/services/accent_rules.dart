import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';

class AccentRules {
  static bool isAccentedBeat(int beatNumber, BeatPattern pattern) {
    if (pattern.noteValue == NoteValue.eighth && pattern.beatsPerBar % 3 == 0) {
      return (beatNumber - 1) % 3 == 0;
    }

    return beatNumber == 1;
  } 
}