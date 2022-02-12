import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
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
  final Mode? mode;

  final Widget? unitChild;

  const HexagonButton({
    Key? key,
    this.enabled = true,
    this.icon,
    this.iconOffset = Offset.zero,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Hexagon(
              center: widget.center,
              radius: widget.radius * 0.8,
              color: _color,
              repaint: true,
            ),
            if (widget.unitChild != null)
              Transform.translate(
                offset: widget.center,
                child: Transform.scale(
                  scale: widget.radius / 2,
                  // TODO widget.enabled IF needed
                  child: widget.unitChild,
                ),
              ),
            if (widget.icon != null)
              Transform.translate(
                offset: widget.center +
                    widget.iconOffset +
                    unitOffset * -IconTheme.of(context).size! / 2,
                child: Icon(
                  widget.icon,
                  color: getColor(widget.enabled ? Side.br : Side.bl),
                ),
              ),
            Transform.translate(
              offset: widget.center - const Offset(W, H * 2) * widget.radius,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!widget.enabled) {
                    return;
                  }
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

  Color get _color => widget.mode != null
      ? getMode(context, listen: true) != widget.mode!
          ? Color.lerp(
              getColor(Side.t),
              getColor(Side.br),
              0.3,
            )!
          : getButtonColor(0.3)
      : getButtonColor(_controller.value);
}
