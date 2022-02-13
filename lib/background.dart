import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/material.dart';

/// The background and safe area have the same color.
/// Sometimes the color is animated.
class Background extends StatefulWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BackgroundState();
}

class BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Color? color;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 33),
      vsync: this,
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreen(context);

    color =
        // backgroundColor;
        getGestureMode(context, listen: true) == GestureMode.panZoom
            ? null
            : backgroundColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: _getColor(),
          child: SafeArea(child: widget.child),
        );
      },
    );
  }

  Color? _getColor() {
    return color ??
        _colorSequence.evaluate(AlwaysStoppedAnimation(_controller.value));
  }
}

final Animatable<Color?> _colorSequence = TweenSequence<Color?>(
  [
    TweenSequenceItem(
      weight: 10.0,
      tween: ColorTween(
        begin: getColor(Side.bl),
        end: getColor(Side.t),
      ),
    ),
    TweenSequenceItem(
      weight: 5.0,
      tween: ColorTween(
        begin: getColor(Side.t),
        end: getColor(Side.br),
      ),
    ),
    TweenSequenceItem(
      weight: 4.0,
      tween: ColorTween(
        begin: getColor(Side.br),
        end: getColor(Side.t),
      ),
    ),
    TweenSequenceItem(
      weight: 10.0,
      tween: ColorTween(
        begin: getColor(Side.t),
        end: getColor(Side.bl),
      ),
    ),
  ],
);
