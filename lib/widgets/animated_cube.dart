import 'package:cube_painter/widgets/cube.dart';
import 'package:flutter/material.dart';

class AnimatedCube extends StatefulWidget {
  const AnimatedCube({Key? key}) : super(key: key);

  @override
  _AnimatedCubeState createState() => _AnimatedCubeState();
}

class _AnimatedCubeState extends State<AnimatedCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    super.initState();
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
        return Transform.scale(
          scale: _controller.value,
          child: const Cube(),
        );
      },
    );
  }
}
