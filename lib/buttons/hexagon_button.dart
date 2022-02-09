import 'package:cube_painter/buttons/calc_hexagon_points.dart';
import 'package:cube_painter/buttons/hexagon_painter.dart';
import 'package:cube_painter/notifiers/mode_notifier.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/side.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class HexagonButton extends StatefulWidget {
  final IconData? icon;
  final VoidCallback? onPressed;

  final Offset center;
  final double radius;

  final Mode? mode;

  final Widget? unitChild;

  const HexagonButton({
    Key? key,
    this.icon,
    this.unitChild,
    this.onPressed,
    required this.center,
    required this.radius,
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

    if (widget.mode == getMode(context)) {
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
        return Stack(
          children: [
            CustomPaint(
              painter: HexagonPainter(
                context: context,
                path: path,
                alpha: _getAlpha(context),
                color: color,
                repaint: true,
              ),
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
                offset: widget.center +
                    const Offset(1, 1) * -IconTheme.of(context).size! / 2,
                child: Icon(widget.icon),
              ),
            Transform.translate(
              offset: widget.center - const Offset(W, H * 2) * widget.radius,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                    if (widget.mode != null) {
                      final modeNotifier =
                        Provider.of<ModeNotifier>(context, listen: false);

                    modeNotifier.mode = widget.mode!;
                    _controller.forward();
                  } else {
                      _controller.reset();
                      _controller.forward();
                    }
                    widget.onPressed?.call();
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
      final modeNotifier = Provider.of<ModeNotifier>(context, listen: true);
      if (modeNotifier.mode != widget.mode!) {
        alpha = 1;
      }
    }
    return alpha;
  }

  Color? get color {
    if (widget.mode != null) {
      final modeNotifier = Provider.of<ModeNotifier>(context, listen: true);

      if (modeNotifier.mode != widget.mode!) {
        return Color.lerp(
          getColor(Side.t),
          getColor(Side.br),
          0.3,
        )!;
      }
    }
    return null;
  }
}
