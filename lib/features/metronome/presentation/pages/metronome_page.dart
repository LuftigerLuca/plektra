import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plektra/core/di/service_locator.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';
import '../bloc/metronome_bloc.dart';
import '../bloc/metronome_event.dart';
import '../bloc/metronome_state.dart';

class MetronomePage extends StatelessWidget {
  const MetronomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MetronomeBloc>(
      create: (_) => getIt<MetronomeBloc>(),
      child: const _MetronomeView(),
    );
  }
}

class _MetronomeView extends StatelessWidget {
  const _MetronomeView();

  // Für den ersten Test fest verdrahtet: 4/4, 120 BPM.
  // BPM-Slider und Taktart-Auswahl kommen als nächster Schritt.
  static const _testPattern = BeatPattern(
    bpm: 120,
    beatsPerBar: 4,
    noteValue: NoteValue.quarter,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metronom')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<MetronomeBloc, MetronomeState>(
              builder: (context, state) {
                return _BeatIndicator(state: state);
              },
            ),
            const SizedBox(height: 48),
            BlocBuilder<MetronomeBloc, MetronomeState>(
              builder: (context, state) {
                final isRunning = state is MetronomeRunning;
                return FloatingActionButton.extended(
                  onPressed: () {
                    final bloc = context.read<MetronomeBloc>();
                    if (isRunning) {
                      bloc.add(MetronomeStopped());
                    } else {
                      bloc.add(MetronomeStarted(_testPattern));
                    }
                  },
                  icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(isRunning ? 'Stop' : 'Start'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BeatIndicator extends StatelessWidget {
  final MetronomeState state;
  const _BeatIndicator({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is MetronomeError) {
      return Text(
        'Fehler: ${(state as MetronomeError).message}',
        style: const TextStyle(color: Colors.red),
      );
    }

    final isRunning = state is MetronomeRunning;
    final isAccented = isRunning && (state as MetronomeRunning).isAccented;
    final currentBeat = isRunning ? (state as MetronomeRunning).currentBeat : 0;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: isAccented ? 100 : 70,
          height: isAccented ? 100 : 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isRunning
                ? (isAccented ? Colors.orange : Colors.blue)
                : Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isRunning ? 'Beat $currentBeat' : 'Bereit',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}