import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';

abstract class MetronomeEvent {}

class MetronomeStarted extends MetronomeEvent {
  final BeatPattern pattern;
  MetronomeStarted(this.pattern);
}

class MetronomeStopped extends MetronomeEvent {}