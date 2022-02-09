import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/buttons/hexagon_painter.dart';
import 'package:cube_painter/buttons/mode_holder.dart';
import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HexagonButton extends StatefulWidget {
  final IconData? icon;
  final VoidCallback? onPressed;

  final Offset center;
  final double radius;

  final bool enabled;
  final Mode? mode;

  const HexagonButton({
    Key? key,
    this.icon,
    this.onPressed,
    required this.center,
    required this.radius,
    this.enabled = true,
    this.mode,
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

    final modeHolder = Provider.of<ModeHolder>(context, listen: false);

    if (widget.mode == modeHolder.mode) {
      _controller.value = 0;
    }
  }

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
                alpha: _getAlpha(context),
                color: _getColor(),
                borderColor: _getBorderColor(),
              ),
            ),
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
                    if (widget.mode != null) {
                      final modeHolder =
                          Provider.of<ModeHolder>(context, listen: false);

                      modeHolder.mode = widget.mode!;
                      _controller.reverse();
                    } else {
                      _controller.reset();
                      _controller.forward();
                    }
                    widget.onPressed?.call();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  double _getAlpha(BuildContext context) {
    double alpha = _controller.value;
    if (widget.mode != null) {
      final modeHolder = Provider.of<ModeHolder>(context, listen: true);
      if (modeHolder.mode != widget.mode!) {
        alpha = 1;
      }
    }
    return alpha;
  }

  Color? _getColor() {
    if (widget.mode != null) {
      final modeHolder = Provider.of<ModeHolder>(context, listen: true);

      if (modeHolder.mode == widget.mode!) {
        return getColor(Side.br);
      }
    }
    return null;
  }

  Color? _getBorderColor() {
    return null;
  }
}
