import 'package:flutter/material.dart';

class SoftPageMotion extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offsetY;

  const SoftPageMotion({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 260),
    this.offsetY = 0.04, // ~8–12px depending on screen height
  });

  @override
  State<SoftPageMotion> createState() => _SoftPageMotionState();
}

class _SoftPageMotionState extends State<SoftPageMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slide = Tween<Offset>(
      begin: Offset(0, widget.offsetY),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

