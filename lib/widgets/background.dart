import 'package:cube_painter/notifiers/mode_notifier.dart';
import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Screen.init(context);
    final modeHolder = Provider.of<ModeNotifier>(context, listen: true);

    // TODO REMove but check radio buttons still work
    // color = modeHolder.mode == Mode.zoomPan ? null : backgroundColor;
    color = _getModeColor(modeHolder.mode);

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

Color? _getModeColor(Mode mode) {
  switch (mode) {
    case Mode.zoomPan:
      return null;
    case Mode.add:
      return getColor(Side.bl);
    case Mode.erase:
      return getColor(Side.t);
    case Mode.crop:
      return getColor(Side.br);
  }
}