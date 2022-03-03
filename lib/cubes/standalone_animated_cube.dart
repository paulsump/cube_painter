import 'dart:ui';

import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/cubes/whole_unit_cube.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

import 'unit_ping_pong.dart';

/// Unit cube or slice that animates itself based the fields passed in.
class StandAloneAnimatedCube extends StatefulWidget {
  final CubeInfo info;

  final double start;
  final double end;

  final bool isPingPong;

  final int milliseconds;

  final Widget _unitCube;

  final Offset _offset;

  StandAloneAnimatedCube({
    Key? key,
    required this.info,
    this.start = 0.0,
    this.end = 1.0,
    this.isPingPong = true,
    this.milliseconds = 3000,
  })  : _unitCube = info.slice == Slice.whole
            ? const WholeUnitCube()
            : SliceUnitCube(slice: info.slice),
        _offset = positionToUnitOffset(info.center),
        super(key: key);

  @override
  _StandAloneAnimatedCubeState createState() => _StandAloneAnimatedCubeState();
}

class _StandAloneAnimatedCubeState extends State<StandAloneAnimatedCube>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milliseconds),
      vsync: this,
    );

    if (widget.start != widget.end) {
      if (widget.isPingPong) {
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
        widget.start,
        widget.end,
        widget.isPingPong
            ? calcUnitPingPong(_controller.value)
            : _controller.value,
      )!;
}
