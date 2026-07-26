import 'package:flutter/painting.dart';

abstract final class AppTextStyles {
  /// BPM display: JetBrainsMono, 96px, w300, tight spacing
  static const bpmDisplay = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 96,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.03,
  );

  /// Section labels: JetBrainsMono, 11px, w600, wide tracking, uppercase
  static const sectionLabel = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.16,
  );

  /// Card titles: Instrument Sans, 10px, w600, tracking 0.10
  static const cardTitle = TextStyle(
    fontFamily: 'InstrumentSans',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
  );

  /// Value/badge text: JetBrainsMono, w600
  static const valueText = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontWeight: FontWeight.w600,
  );
}
