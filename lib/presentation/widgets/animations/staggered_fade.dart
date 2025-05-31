import 'package:animations/animations.dart';
import 'package:e_porter/presentation/widgets/animations/animation_configs.dart';
import 'package:flutter/material.dart';

class StaggeredFadeAnimation extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration? delay;
  final Duration? duration;
  final SharedAxisTransitionType transitionType;
  final bool reverse;

  const StaggeredFadeAnimation({
    Key? key,
    required this.child,
    required this.index,
    this.delay,
    this.duration,
    this.transitionType = SharedAxisTransitionType.vertical,
    this.reverse = false,
  }) : super(key: key);

  @override
  State<StaggeredFadeAnimation> createState() => _StaggeredFadeAnimationState();
}

class _StaggeredFadeAnimationState extends State<StaggeredFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration ?? AnimationConfigs.sharedAxisDuration,
      vsync: this,
    );

    // Calculate staggered delay
    final totalDelay = (widget.delay ?? AnimationConfigs.baseDelay) +
        Duration(milliseconds: AnimationConfigs.itemDelay.inMilliseconds * widget.index);

    // Start animation after delay
    Future.delayed(totalDelay, () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageTransitionSwitcher(
        duration: widget.duration ?? AnimationConfigs.sharedAxisDuration,
        reverse: widget.reverse,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            fillColor: Colors.transparent,
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: widget.transitionType,
            child: child,
          );
        },
        child: _isVisible 
            ? widget.child 
            : const SizedBox.shrink(),
      ),
    );
  }
}