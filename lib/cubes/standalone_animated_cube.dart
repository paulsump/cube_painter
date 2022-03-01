import 'dart:ui';

import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

import 'unit_ping_pong.dart';

const noWarn = [out, Slice, UnitToScreen];

/// Params for creating [AnimCube]s
// TODO rename to AnimCubeFields
class Fields {
  final CubeInfo info;

  final double start;
  final double end;

  final bool isPingPong;

  final int milliseconds;

  Fields({
    required this.info,
    this.start = 0.0,
    this.end = 1.0,
    this.isPingPong = true,
    this.milliseconds = 3000,
  });
}

/// Unit cube or slice that animates itself based the [Fields] passed in.
/// It was fun to see if it worked putting the anim controller on every widget
/// and it does, as long as you never need the anim controller value e.g. if you want to
/// recreate the cubes elsewhere or with a different animation, starting at the same place.
class AnimCube extends StatefulWidget {
  final Fields fields;

  final Widget _unitCube;

  final Offset _offset;

  AnimCube({
    Key? key,
    required this.fields,
  })  : _unitCube = fields.info.slice == Slice.whole
            ? const WholeUnitCube()
            : SliceUnitCube(slice: fields.info.slice),
        _offset = positionToUnitOffset(fields.info.center),
        super(key: key);

  @override
  _AnimCubeState createState() => _AnimCubeState();
}

class _AnimCubeState extends State<AnimCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.fields.milliseconds),
      vsync: this,
    );

    if (widget.fields.start != widget.fields.end) {
      if (widget.fields.isPingPong) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
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

        return Stack(
          children: [
            Transform.translate(
              offset: widget._offset,
              child: Transform.scale(
                scale: _scale(),
                child: widget._unitCube,
              ),
            ),
          ],
        );
      },
    );
  }

  double _scale() => lerpDouble(
        widget.fields.start,
        widget.fields.end,
    widget.fields.isPingPong
            ? unitPingPong(_controller.value)
            : _controller.value,
      )!;
}
