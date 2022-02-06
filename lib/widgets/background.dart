import 'package:cube_painter/shared/colors.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:flutter/material.dart';

/// animated background
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // duration: const Duration(seconds: 1),
      duration: const Duration(seconds: 80),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screen.init(context);

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  color: _colorSequence.evaluate(
                    AlwaysStoppedAnimation(_controller.value),
                  ),
                ),
                widget.child,
              ],
            );
          },
        ),
      ),
    );
  }
}

Animatable<Color?> _colorSequence = TweenSequence<Color?>(
  [
    TweenSequenceItem(
      weight: 10.0,
      tween: ColorTween(
        begin: getColor(Vert.bl),
        end: getColor(Vert.t),
      ),
    ),
    TweenSequenceItem(
      weight: 5.0,
      tween: ColorTween(
        begin: getColor(Vert.t),
        end: getColor(Vert.br),
      ),
    ),
    TweenSequenceItem(
      weight: 4.0,
      tween: ColorTween(
        begin: getColor(Vert.br),
        end: getColor(Vert.t),
      ),
    ),
    TweenSequenceItem(
      weight: 10.0,
      tween: ColorTween(
        begin: getColor(Vert.t),
        end: getColor(Vert.bl),
      ),
    ),
  ],
);
