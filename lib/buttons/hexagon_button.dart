import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/buttons/hexagon_painter.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:flutter/material.dart';

class HexagonButton extends StatefulWidget {
  final IconData? icon;
  final VoidCallback? onPressed;

  final VoidCallback? onRadioPressed;
  final bool? isRadioDown;

  final Offset center;
  final double radius;

  final bool enabled;

  const HexagonButton({
    Key? key,
    this.icon,
    this.onPressed,
    this.isRadioDown,
    this.onRadioPressed,
    required this.center,
    required this.radius,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<HexagonButton> createState() => _HexagonState();
}

class _HexagonState extends State<HexagonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _controller.value = 1;

    if (_isRadio && widget.isRadioDown!) {
      _controller.value = 0;
    }
  }

  bool get _isRadio => widget.onRadioPressed != null;

  @override
  Widget build(BuildContext context) {
    final List<Offset> points = calcHexagonPoints(widget.center, widget.radius);
    final Path path = Path()..addPolygon(points, true);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double w = IconTheme.of(context).size! / 2;
        final o = Offset(-w, -w);

        return Stack(
          children: [
            CustomPaint(
              painter: HexagonPainter(
                context: context,
                path: path,
                alpha: _controller.value,
              ),
            ),
            // Line(widget.center - o * 2, widget.center + o * 2),
            if (widget.icon != null)
              Transform.translate(
                offset: o + widget.center,
                child: widget.enabled ? Icon(widget.icon) : null,
              ),
            Transform.translate(
              offset: widget.center -
                  const Offset(W, H * 2) * getZoomScale(context),
              // TODO fix inaccuracy with gesture clip
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.enabled) {
                    if (_isRadio) {
                      _controller.reverse();
                    } else {
                      _controller.reset();
                      _controller.forward();
                    }
                    widget.onPressed?.call();
                    widget.onRadioPressed?.call();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
