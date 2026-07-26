import 'package:flutter/material.dart';
import 'package:plektra/core/di/service_locator.dart';
import 'package:plektra/core/theme/app_colors.dart';
import 'package:plektra/features/metronome/presentation/pages/metronome_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: ShadThemeData(
        colorScheme: ShadColorScheme(
          background: AppColors.background,
          foreground: AppColors.foreground,
          card: AppColors.card,
          cardForeground: AppColors.cardForeground,
          popover: AppColors.card,
          popoverForeground: AppColors.cardForeground,
          primary: AppColors.primary,
          primaryForeground: AppColors.primaryForeground,
          secondary: AppColors.secondary,
          secondaryForeground: AppColors.secondaryForeground,
          muted: AppColors.muted,
          mutedForeground: AppColors.mutedForeground,
          accent: AppColors.secondary,
          accentForeground: AppColors.secondaryForeground,
          destructive: AppColors.destructive,
          destructiveForeground: AppColors.destructiveForeground,
          border: AppColors.border,
          input: AppColors.border,
          ring: AppColors.ring,
          selection: AppColors.selection,
        ),
        radius: const BorderRadius.all(Radius.circular(16)),
        textTheme: ShadTextTheme(
          family: 'InstrumentSans',
        ),
        primaryButtonTheme: const ShadButtonTheme(
          backgroundColor: AppColors.primary,
          hoverBackgroundColor: AppColors.primaryHover,
          foregroundColor: AppColors.primaryForeground,
          textStyle: TextStyle(
            fontFamily: 'InstrumentSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        sliderTheme: const ShadSliderTheme(
          activeTrackColor: AppColors.primary,
          thumbBorderColor: AppColors.primary,
        ),
        primaryBadgeTheme: const ShadBadgeTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.foreground,
        ),
      ),
      home: const MetronomePage(),
    );
  }
}
