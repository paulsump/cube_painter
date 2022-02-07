import 'dart:math';
import 'dart:ui';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class Cube extends StatefulWidget {
  final GridPoint center;

  final Crop crop;
  final double start;
  final double end;
  final bool pingPong;

  //TODO reverse for delete
  // final bool direction;

  const Cube({
    Key? key,
    required this.center,
    required this.crop,
    required this.start,
    required this.end,
    this.pingPong = false,
  }) : super(key: key);

  @override
  _CubeState createState() => _CubeState();
}

class _CubeState extends State<Cube> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Offset offset;
  late Widget cube;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    if (widget.start != widget.end) {
      if (widget.pingPong) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }

    offset = gridToUnit(widget.center);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // out(offset);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Transform.translate(
              offset: offset,
              child: Transform.scale(
                scale: _scale(),
                //TODO SimpleCube - opacity means can't pick crop in initState
                child: widget.crop == Crop.c
                //TODO SimpleCube - opacity means not using const UnitCube
                    ? UnitCube(opacity: _scale())
                    : CroppedUnitCube(crop: widget.crop),
              ),
            ),
            //TODO SimpleCube - don't need this if no wire field
            Transform.translate(
              offset: offset,
              child: const UnitCube(wire: true),
            ),
          ],
        );
      },
    );
  }

  double _scale() => lerpDouble(
        widget.start,
        widget.end,
        widget.pingPong
            ? (1 + sin(2 * pi * _controller.value) / 2)
            : _controller.value,
      )!;
}
