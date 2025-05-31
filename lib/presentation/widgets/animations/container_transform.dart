import 'package:animations/animations.dart';
import 'package:e_porter/presentation/widgets/animations/animation_configs.dart';
import 'package:flutter/material.dart';

enum AnimationType {
  fadeThrough,
  sharedAxisVertical,
  sharedAxisHorizontal,
  sharedAxisScaled,
}

class ContainerTransformAnimation extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration? duration;
  final AnimationType animationType;

  const ContainerTransformAnimation({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration,
    this.animationType = AnimationType.fadeThrough,
  }) : super(key: key);

  @override
  State<ContainerTransformAnimation> createState() => _ContainerTransformAnimationState();
}

class _ContainerTransformAnimationState extends State<ContainerTransformAnimation> {
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

  Widget _buildTransition(Widget child, Animation<double> primaryAnimation, Animation<double> secondaryAnimation) {
    switch (widget.animationType) {
      case AnimationType.fadeThrough:
        return FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      case AnimationType.sharedAxisVertical:
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          child: child,
        );
      case AnimationType.sharedAxisHorizontal:
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      case AnimationType.sharedAxisScaled:
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.scaled,
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageTransitionSwitcher(
        duration: widget.duration ?? AnimationConfigs.containerTransformDuration,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return _buildTransition(child, primaryAnimation, secondaryAnimation);
        },
        child: _isVisible ? widget.child : const SizedBox.shrink(),
      ),
    );
  }
}
