import 'package:plektra/features/metronome/domain/entities/beat_event.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/repositories/metronome_repository.dart';
import 'package:plektra/features/metronome/domain/services/accent_rules.dart';

class StartMetronomeUsecase {
  final MetronomeRepository repository;
  StartMetronomeUsecase(this.repository);

  Stream<BeatEvent> call(BeatPattern pattern) {
    return repository.start(pattern).map((beatNumber) {
      return BeatEvent(
        beatNumber: beatNumber, 
        isAccented: AccentRules.isAccentedBeat(beatNumber, pattern),
        );
    });
  }
}