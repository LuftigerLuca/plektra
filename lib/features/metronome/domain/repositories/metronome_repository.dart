import 'package:plektra/features/metronome/domain/entities/beat_event.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';

abstract class MetronomeRepository {
  Stream<BeatEvent> start(BeatPattern pattern);
  Future<void> stop();
}
