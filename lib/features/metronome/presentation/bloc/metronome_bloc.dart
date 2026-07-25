import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plektra/features/metronome/presentation/bloc/metronome_event.dart';
import 'package:plektra/features/metronome/presentation/bloc/metronome_state.dart';
import 'package:plektra/features/metronome/domain/usecases/start_metronome_usecase.dart';

class MetronomeBloc extends Bloc<MetronomeEvent, MetronomeState> {
  final StartMetronomeUsecase startMetronome;

  MetronomeBloc(this.startMetronome) : super(MetronomeIdle()) {
    on<MetronomeStarted>(_onStarted);
    on<MetronomeStopped>(_onStopped);
  }

  Future<void> _onStarted(
    MetronomeStarted event,
    Emitter<MetronomeState> emit,
  ) async {
    await emit.forEach(
      startMetronome(event.pattern),
      onData: (data) => MetronomeRunning(
        currentBeat: data.beatNumber, 
        isAccented: data.isAccented
      ),
      onError: (error, stackTrace) => MetronomeError(error.toString()),
    );
  }


  Future<void> _onStopped(
    MetronomeStopped event,
    Emitter<MetronomeState> emit,
  ) async {
    emit(MetronomeIdle());
  }
}