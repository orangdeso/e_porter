import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimationConfigs {
  // === FADE THROUGH TRANSITIONS ===
  static const Duration fadeTransitionDuration = Duration(milliseconds: 800);
  static const Duration fadeTransitionReverseDuration = Duration(milliseconds: 500);

  // === SHARED AXIS TRANSITIONS ===
  static const Duration sharedAxisDuration = Duration(milliseconds: 600);
  static const SharedAxisTransitionType horizontalTransition = SharedAxisTransitionType.horizontal;
  static const SharedAxisTransitionType verticalTransition = SharedAxisTransitionType.vertical;
  static const SharedAxisTransitionType scaledTransition = SharedAxisTransitionType.scaled;

  // === CONTAINER TRANSFORM ===
  static const Duration containerTransformDuration = Duration(milliseconds: 700);

  // === CUSTOM CURVES ===
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubic;

  // === STAGGER DELAYS ===
  static const Duration baseDelay = Duration(milliseconds: 300);
  static const Duration itemDelay = Duration(milliseconds: 150);
  static const Duration buttonDelay = Duration(milliseconds: 200);

  // === MODAL TRANSITIONS ===
  static const Duration modalDuration = Duration(milliseconds: 500);
  static const Duration overlayDuration = Duration(milliseconds: 300);
}