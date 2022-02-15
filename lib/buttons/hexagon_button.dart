import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class HexagonButton extends StatefulWidget {
  final bool enabled;
  final IconData? icon;

  final VoidCallback? onPressed;
  final Offset center;
  final Offset iconOffset;

  final double radius;
  final GestureMode? gestureMode;

  final Widget? unitChild;

  const HexagonButton({
    Key? key,
    required this.center,
    required this.radius,
    this.enabled = true,
    this.icon,
    this.iconOffset = Offset.zero,
    this.unitChild,
    this.onPressed,
    this.gestureMode,
  }) : super(key: key);

  @override
  State<HexagonButton> createState() => _HexagonState();
}

class _HexagonState extends State<HexagonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _controller.value = 1;

    if (widget.gestureMode == getGestureMode(context)) {
      _controller.value = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = IconTheme.of(context).size!;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(children: [
            Hexagon(
              center: widget.center,
              radius: widget.radius,
              color: _color,
              repaint: true,
            ),
            if (widget.unitChild != null)
              Transform.translate(
                offset: widget.center,
                child: Transform.scale(
                  scale: widget.radius / 2,
                  child: widget.unitChild,
                ),
              ),
            if (widget.icon != null)
              Transform.translate(
                offset:
                    widget.center + widget.iconOffset + unit * -iconSize / 2,
                child: Transform.scale(
                  scale: 0.8 * widget.radius / iconSize,
                  child: Icon(
                    widget.icon,
                    color: getColor(widget.enabled ? Side.br : Side.bl),
                  ),
                ),
              ),
            ClipOval(
              clipper: _CircleClipper(
                radius: widget.radius * W,
                center: widget.center,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!widget.enabled) {
                    return;
                  }
                  if (widget.gestureMode != null) {
                    final gestureModeNotifier =
                        Provider.of<GestureModeNotifier>(context,
                            listen: false);

                    gestureModeNotifier.mode = widget.gestureMode!;
                    _controller.forward();
                  } else {
                    _controller.reset();
                    _controller.forward();
                  }
                  widget.onPressed?.call();
                },
              ),
            ),
          ]);
        });
  }

  Color get _color => widget.gestureMode != null
      ? getGestureMode(context, listen: true) != widget.gestureMode!
          ? radioButtonOffColor
          : radioButtonOnColor
      : getButtonColor(_controller.value);
}

class _CircleClipper extends CustomClipper<Rect> {
  final double radius;
  final Offset center;

  const _CircleClipper({required this.radius, required this.center});

  @override
  Rect getClip(Size size) => Rect.fromCircle(center: center, radius: radius);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
