import 'dart:math';
import 'dart:ui';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class AnimCube extends StatefulWidget {
  final CubeInfo info;
  final double start;
  final double end;
  final bool pingPong;

  //TODO reverse for delete
  // final bool direction;

  final dynamic Function(AnimCube old)? whenComplete;

  const AnimCube({
    Key? key,
    required this.info,
    required this.start,
    required this.end,
    this.pingPong = false,
    this.whenComplete,
  }) : super(key: key);

  @override
  _AnimCubeState createState() => _AnimCubeState();
}

class _AnimCubeState extends State<AnimCube> with SingleTickerProviderStateMixin {
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
        _controller.forward().whenComplete(widget.whenComplete?.call(widget));
      }
    }

    offset = gridToUnit(widget.info.center);
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
                child: widget.info.crop == Crop.c
                    ? UnitCube(opacity: _scale())
                    : CroppedUnitCube(crop: widget.info.crop),
              ),
            ),
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
