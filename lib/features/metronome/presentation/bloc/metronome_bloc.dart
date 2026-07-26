import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plektra/features/metronome/domain/entities/beat_mode.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/repositories/metronome_repository.dart';
import 'package:plektra/features/metronome/presentation/bloc/metronome_event.dart';
import 'package:plektra/features/metronome/presentation/bloc/metronome_state.dart';

class MetronomeBloc extends Bloc<MetronomeEvent, MetronomeState> {
  final MetronomeRepository _repository;
  BeatPattern _currentPattern;
  StreamSubscription? _subscription;

  MetronomeBloc(this._repository)
      : _currentPattern = const BeatPattern(bpm: 120, beatsPerBar: 4),
        super(MetronomeIdle(
          pattern: const BeatPattern(bpm: 120, beatsPerBar: 4),
        )) {
    on<MetronomeStarted>(_onStarted);
    on<MetronomeStopped>(_onStopped);
    on<MetronomeBpmChanged>(_onBpmChanged);
    on<MetronomePatternChanged>(_onPatternChanged);
    on<MetronomeNoteValueChanged>(_onNoteValueChanged);
    on<MetronomeBeatModeChanged>(_onBeatModeChanged);
    on<_MetronomeTick>(_onTick);
    on<MetronomeErrorEvent>(_onError);
  }

  Future<void> _onStarted(
    MetronomeStarted event,
    Emitter<MetronomeState> emit,
  ) async {
    _currentPattern = event.pattern;
    await _subscription?.cancel();
    _subscription = _repository.start(event.pattern).listen(
      (data) => add(_MetronomeTick(data.beatNumber, data.mode)),
      onError: (error) {
        add(MetronomeStopped());
        add(MetronomeErrorEvent(error.toString()));
      },
    );
  }

  void _onTick(_MetronomeTick event, Emitter<MetronomeState> emit) {
    emit(MetronomeRunning(
      pattern: _currentPattern,
      currentBeat: event.beatNumber,
      currentMode: event.mode,
    ));
  }

  void _onError(MetronomeErrorEvent event, Emitter<MetronomeState> emit) {
    emit(MetronomeError(event.message));
  }

  Future<void> _onStopped(
    MetronomeStopped event,
    Emitter<MetronomeState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = null;
    emit(MetronomeIdle(pattern: _currentPattern));
  }

  Future<void> _onBpmChanged(
    MetronomeBpmChanged event,
    Emitter<MetronomeState> emit,
  ) async {
    final newPattern = _currentPattern.copyWith(bpm: event.bpm);
    _currentPattern = newPattern;
    if (state is MetronomeRunning) {
      add(MetronomeStarted(newPattern));
    }
  }

  Future<void> _onPatternChanged(
    MetronomePatternChanged event,
    Emitter<MetronomeState> emit,
  ) async {
    _currentPattern = event.pattern;
    if (state is MetronomeRunning) {
      add(MetronomeStarted(event.pattern));
    } else {
      emit(MetronomeIdle(pattern: _currentPattern));
    }
  }

  Future<void> _onNoteValueChanged(
    MetronomeNoteValueChanged event,
    Emitter<MetronomeState> emit,
  ) async {
    final newPattern = _currentPattern.copyWith(noteValue: event.noteValue);
    _currentPattern = newPattern;
    if (state is MetronomeRunning) {
      add(MetronomeStarted(newPattern));
    } else {
      emit(MetronomeIdle(pattern: _currentPattern));
    }
  }

  Future<void> _onBeatModeChanged(
    MetronomeBeatModeChanged event,
    Emitter<MetronomeState> emit,
  ) async {
    final newModes = Map<int, BeatMode>.from(_currentPattern.beatModes);
    newModes[event.beatNumber] = event.mode;
    final newPattern = _currentPattern.copyWith(beatModes: newModes);
    _currentPattern = newPattern;
    if (state is MetronomeRunning) {
      add(MetronomeStarted(newPattern));
    } else {
      emit(MetronomeIdle(pattern: _currentPattern));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

class _MetronomeTick extends MetronomeEvent {
  final int beatNumber;
  final BeatMode mode;
  _MetronomeTick(this.beatNumber, this.mode);
}
