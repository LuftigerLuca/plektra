import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plektra/core/di/service_locator.dart';
import 'package:plektra/core/theme/app_colors.dart';
import 'package:plektra/core/theme/app_text_styles.dart';
import 'package:plektra/features/metronome/domain/entities/beat_pattern.dart';
import 'package:plektra/features/metronome/domain/entities/note_value.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocBuilder<MetronomeBloc, MetronomeState>(
            builder: (context, state) {
              final pattern = _patternFromState(state);
              final isRunning = state is MetronomeRunning;
              final currentBeat = isRunning ? state.currentBeat : 0;
              final beatsPerBar = pattern.beatsPerBar;

              return Column(
                children: [
                  const SizedBox(height: 32),
                  _BeatDots(
                    beatsPerBar: beatsPerBar,
                    currentBeat: currentBeat,
                    isRunning: isRunning,
                  ),
                  const SizedBox(height: 16),
                  _BpmInput(bpm: pattern.bpm),
                  const SizedBox(height: 40),
                  _SettingsCard(pattern: pattern),
                  const Spacer(),
                  _StartStopButton(isRunning: isRunning, pattern: pattern),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  BeatPattern _patternFromState(MetronomeState state) {
    if (state is MetronomeRunning) {
      return BeatPattern(
        bpm: state.bpm,
        beatsPerBar: state.beatsPerBar,
        noteValue: state.noteValue,
      );
    }
    if (state is MetronomeIdle) return state.pattern;
    return const BeatPattern(bpm: 120, beatsPerBar: 4);
  }
}

class _BeatDots extends StatelessWidget {
  final int beatsPerBar;
  final int currentBeat;
  final bool isRunning;

  const _BeatDots({
    required this.beatsPerBar,
    required this.currentBeat,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(beatsPerBar, (index) {
        final beatNumber = index + 1;
        final isActive = isRunning && currentBeat == beatNumber;
        final isAccent = beatNumber == 1;

        return Padding(
          padding: EdgeInsets.only(right: index < beatsPerBar - 1 ? 12 : 0),
          child: _BeatDot(
            isActive: isActive,
            isAccent: isAccent,
          ),
        );
      }),
    );
  }
}

class _BeatDot extends StatelessWidget {
  final bool isActive;
  final bool isAccent;

  const _BeatDot({required this.isActive, required this.isAccent});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    if (isActive) {
      final color = isAccent ? AppColors.success : theme.colorScheme.primary;
      final borderColor =
          isAccent ? AppColors.successBorder : theme.colorScheme.muted;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: borderColor,
            width: 3,
          ),
        ),
      );
    }

    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.disabled,
      ),
    );
  }
}

class _BpmInput extends StatelessWidget {
  final int bpm;

  const _BpmInput({required this.bpm});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final bloc = context.read<MetronomeBloc>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadIconButton.ghost(
              icon: const Icon(LucideIcons.minus),
              onPressed: bpm > 20
                  ? () => bloc.add(MetronomeBpmChanged(bpm - 1))
                  : null,
            ),
            GestureDetector(
              onTap: () => _showBpmDialog(context, bloc),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$bpm',
                    style: AppTextStyles.bpmDisplay,
                  ),
                ),
            ),
            ShadIconButton.ghost(
              icon: const Icon(LucideIcons.plus),
              onPressed: bpm < 300
                  ? () => bloc.add(MetronomeBpmChanged(bpm + 1))
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _showBpmDialog(context, bloc),
          child: Text(
            'TIPPEN ZUM ÄNDERN',
            style: AppTextStyles.sectionLabel.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }

  void _showBpmDialog(BuildContext context, MetronomeBloc bloc) {
    final controller = TextEditingController(text: '$bpm');

    showShadDialog(
      context: context,
      builder: (context) =>
          ShadDialog(
            title: const Text('BPM eingeben'),
            actions: [
              ShadButton.ghost(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Abbrechen'),
              ),
              ShadButton(
                onPressed: () {
                  final parsed = int.tryParse(controller.text);
                  if (parsed != null) {
                    final clamped = parsed.clamp(20, 300);
                    bloc.add(MetronomeBpmChanged(clamped));
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ShadInput(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                placeholder: const Text('20 – 300'),
              ),
            ),
          ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final BeatPattern pattern;

  const _SettingsCard({required this.pattern});

  static const _noteValueLabels = {
    NoteValue.whole: '1',
    NoteValue.half: '2',
    NoteValue.quarter: '4',
    NoteValue.eighth: '8',
    NoteValue.sixteenth: '16',
  };

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final bloc = context.read<MetronomeBloc>();

    return ShadCard(
      width: double.infinity,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TAKTART',
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.mutedForegroundDim,
            ),
          ),
            Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${pattern.beatsPerBar}',
                  style: AppTextStyles.valueText.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: '/',
                  style: AppTextStyles.valueText.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                TextSpan(
                  text: _noteValueLabels[pattern.noteValue],
                  style: AppTextStyles.valueText.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'SCHLÄGE',
                style: AppTextStyles.sectionLabel.copyWith(
                  color: AppColors.mutedForegroundDim,
                ),
              ),
              const SizedBox(height: 16),
              ShadSlider(
                initialValue: pattern.beatsPerBar.toDouble(),
                min: 1,
                max: 12,
                divisions: 11,
                onChanged: (value) {
                  bloc.add(
                    MetronomePatternChanged(
                      pattern.copyWith(beatsPerBar: value.round()),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ShadSeparator.horizontal(),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOTE',
                style: AppTextStyles.sectionLabel.copyWith(
                  color: AppColors.mutedForegroundDim,
                ),
              ),
              const SizedBox(height: 8),
              _NoteValuePills(
                current: pattern.noteValue,
                onSelect: (nv) => bloc.add(MetronomeNoteValueChanged(nv)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoteValuePills extends StatelessWidget {
  final NoteValue current;
  final ValueChanged<NoteValue> onSelect;

  const _NoteValuePills({required this.current, required this.onSelect});

  static const _values = [
    NoteValue.whole,
    NoteValue.half,
    NoteValue.quarter,
    NoteValue.eighth,
    NoteValue.sixteenth,
  ];

  static const _labels = {
    NoteValue.whole: '1/1',
    NoteValue.half: '1/2',
    NoteValue.quarter: '1/4',
    NoteValue.eighth: '1/8',
    NoteValue.sixteenth: '1/16',
  };

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final border = theme.colorScheme.border;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: List.generate(_values.length, (index) {
          final nv = _values[index];
          final isActive = current == nv;
          final isLast = index == _values.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(nv),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  border: isLast
                      ? null
                      : Border(
                          right: BorderSide(color: border),
                        ),
                ),
                child: Text(
                  _labels[nv]!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.valueText.copyWith(
                    color: isActive
                        ? theme.colorScheme.primaryForeground
                        : theme.colorScheme.mutedForeground,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StartStopButton extends StatelessWidget {
  final bool isRunning;
  final BeatPattern pattern;

  const _StartStopButton({required this.isRunning, required this.pattern});

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      expands: true,
      size: ShadButtonSize.lg,
      onPressed: () {
        final bloc = context.read<MetronomeBloc>();
        if (isRunning) {
          bloc.add(MetronomeStopped());
        } else {
          bloc.add(MetronomeStarted(pattern));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isRunning ? LucideIcons.square : LucideIcons.play, size: 18),
          const SizedBox(width: 8),
          Text(
            isRunning ? 'STOP' : 'START',
            style: AppTextStyles.valueText,
          ),
        ],
      ),
    );
  }
}
