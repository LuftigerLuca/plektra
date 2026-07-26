import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';

class BeatEvent {
  final int beatNumber;
  final BeatMode mode;

  const BeatEvent({required this.beatNumber, required this.mode});
}
