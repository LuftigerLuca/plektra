import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';

abstract class MetronomeRepository {
  Stream<int> start(BeatPattern pattern);
  Future<void> stop();
}