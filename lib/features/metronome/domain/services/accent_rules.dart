import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';

class AccentRules {
  static BeatMode resolve(int beatNumber, BeatPattern pattern) {
    final override = pattern.beatModes[beatNumber];
    if (override != null) return override;

    if (pattern.noteValue == NoteValue.eighth && pattern.beatsPerBar % 3 == 0) {
      return (beatNumber - 1) % 3 == 0 ? BeatMode.accent : BeatMode.normal;
    }

    return beatNumber == 1 ? BeatMode.accent : BeatMode.normal;
  }
}
