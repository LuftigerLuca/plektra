import 'package:plektra/features/metronome/data/datasources/click_sound_datasource.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/repositories/metronome_repository.dart';
import 'package:plektra/features/metronome/domain/services/accent_rules.dart';

class MetronomeRepositoryImpl implements MetronomeRepository {
  final ClickSoundDataSource _clickSoundDataSource;
  bool _isRunning = false;

  MetronomeRepositoryImpl(this._clickSoundDataSource);

  @override
  Stream<int> start(BeatPattern pattern) async* {
    await _clickSoundDataSource.init();
    _isRunning = true;

    final intervalMs = (60000 / pattern.bpm).round();
    var currentBeat = 1;
    var nextTick = DateTime.now();

    while (_isRunning) {
      final mode = AccentRules.resolve(currentBeat, pattern);
      await _clickSoundDataSource.playClick(mode: mode);
      yield currentBeat;

      nextTick = nextTick.add(Duration(milliseconds: intervalMs));
      final delay = nextTick.difference(DateTime.now());
      if (delay > Duration.zero) {
        await Future.delayed(delay);
      }

      currentBeat = currentBeat >= pattern.beatsPerBar ? 1 : currentBeat + 1;
    }
  }

  @override
  Future<void> stop() async {
    _isRunning = false;
  }
}
