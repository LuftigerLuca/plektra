import 'package:flutter_test/flutter_test.dart';
import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';
import 'package:plektra/features/metronome/domain/repositories/metronome_repository.dart';
import 'package:plektra/features/metronome/domain/usecases/start_metronome_usecase.dart';

class FakeMetronomeRepository implements MetronomeRepository {
  @override
  Stream<int> start(BeatPattern pattern) {
    return Stream.fromIterable(
      List.generate(pattern.beatsPerBar, (i) => i + 1),
    );
  }

  @override
  Future<void> stop() async {}
}

void main() {
  test('accents only beat 1 in 4/4', () async {
    final useCase = StartMetronomeUsecase(FakeMetronomeRepository());
    final pattern = BeatPattern(bpm: 120, beatsPerBar: 4, noteValue: NoteValue.quarter);

    final events = await useCase(pattern).toList();

    expect(events[0].mode, BeatMode.accent);
    expect(events[1].mode, BeatMode.normal);
    expect(events[2].mode, BeatMode.normal);
    expect(events[3].mode, BeatMode.normal);
  });

  test('accents beats 1 and 4 in 6/8', () async {
    final useCase = StartMetronomeUsecase(FakeMetronomeRepository());
    final pattern = BeatPattern(bpm: 120, beatsPerBar: 6, noteValue: NoteValue.eighth);

    final events = await useCase(pattern).toList();

    expect(events[0].mode, BeatMode.accent);
    expect(events[3].mode, BeatMode.accent);
    expect(events[1].mode, BeatMode.normal);
    expect(events[4].mode, BeatMode.normal);
  });
}
