import 'dart:ui';

import 'package:flutter/material.dart';

class FadeSlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideOffset;
  final Curve curve;
  final bool enableScale;
  final bool enableBlur;
  final double scaleBegin;
  final double scaleEnd;

  const FadeSlideAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.slideOffset = const Offset(0, 0.3),
    this.curve = Curves.easeOutCubic,
    this.enableScale = false,
    this.enableBlur = false,
    this.scaleBegin = 0.3,
    this.scaleEnd = 1.0,
  }) : super(key: key);

  @override
  State<FadeSlideAnimation> createState() => _FadeSlideAnimationState();
}

class _FadeSlideAnimationState extends State<FadeSlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Scale animation (dari kecil ke besar)
    _scaleAnimation = Tween<double>(
      begin: widget.scaleBegin,
      end: widget.scaleEnd,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.enableScale ? Curves.elasticOut : widget.curve,
    ));

    // Blur animation (blur tinggi ke blur rendah/hilang)
    _blurAnimation = Tween<double>(
      begin: widget.enableBlur ? 10.0 : 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget animatedChild = widget.child;

        if (widget.enableScale) {
          animatedChild = Transform.scale(
            scale: _scaleAnimation.value,
            child: animatedChild,
          );
        }

        if (widget.enableBlur) {
          animatedChild = ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _blurAnimation.value,
              sigmaY: _blurAnimation.value,
            ),
            child: animatedChild,
          );
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: animatedChild,
        );
      },
    );
  }
}