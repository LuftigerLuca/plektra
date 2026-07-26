import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/presentation/bloc/metronome_event.dart';
import 'package:plektra/features/metronome/presentation/bloc/metronome_state.dart';
import 'package:plektra/features/metronome/domain/usecases/start_metronome_usecase.dart';

class MetronomeBloc extends Bloc<MetronomeEvent, MetronomeState> {
  final StartMetronomeUsecase startMetronome;
  BeatPattern _currentPattern;
  StreamSubscription? _subscription;

  MetronomeBloc(this.startMetronome)
      : _currentPattern = const BeatPattern(
            bpm: 120,
            beatsPerBar: 4,
          ),
        super(MetronomeIdle(
          pattern: const BeatPattern(bpm: 120, beatsPerBar: 4),
        )) {
    on<MetronomeStarted>(_onStarted);
    on<MetronomeStopped>(_onStopped);
    on<MetronomeBpmChanged>(_onBpmChanged);
    on<MetronomePatternChanged>(_onPatternChanged);
    on<MetronomeNoteValueChanged>(_onNoteValueChanged);
  }

  Future<void> _onStarted(
    MetronomeStarted event,
    Emitter<MetronomeState> emit,
  ) async {
    _currentPattern = event.pattern;
    await _subscription?.cancel();
    await emit.forEach(
      startMetronome(event.pattern),
      onData: (data) => MetronomeRunning(
        currentBeat: data.beatNumber,
        isAccented: data.isAccented,
        bpm: _currentPattern.bpm,
        beatsPerBar: _currentPattern.beatsPerBar,
        noteValue: _currentPattern.noteValue,
      ),
      onError: (error, stackTrace) => MetronomeError(error.toString()),
    );
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

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}