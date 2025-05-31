import 'package:animations/animations.dart';
import 'package:e_porter/presentation/widgets/animations/animation_configs.dart';
import 'package:flutter/material.dart';

class FadeThroughAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration? duration;

  const FadeThroughAnimation({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration,
  }) : super(key: key);

  @override
  State<FadeThroughAnimation> createState() => _FadeThroughAnimationState();
}

class _FadeThroughAnimationState extends State<FadeThroughAnimation> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: widget.duration ?? AnimationConfigs.fadeTransitionDuration,
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return FadeThroughTransition(
          fillColor: Colors.transparent,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: _isVisible 
          ? widget.child 
          : const SizedBox.shrink(),
    );
  }
}