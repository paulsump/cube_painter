import 'dart:ui';

import 'package:cube_painter/cubes/unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter/material.dart';

import '../unit_ping_pong.dart';

const noWarn = [out, Crop];

class AnimCube extends StatefulWidget {
  final CubeInfo info;

  final double start;
  final double end;

  final bool pingPong;
  final bool wire;

  /// This is bad because it's set by the state,
  /// and also  mean this class can't be const
  /// and also causes the warning about
  /// non finals on an @immutable
  double scale = 1;

  final dynamic Function(AnimCube old)? whenComplete;
  final Widget cube;

  final Offset offset;
  final int duration;

  AnimCube({
    Key? key,
    required this.info,
    required this.start,
    required this.end,
    this.pingPong = false,
    this.whenComplete,
    this.duration = 800,
    this.wire = false,
  })  : cube = UnitCube(
          crop: info.crop,
          style: wire ? PaintingStyle.stroke : PaintingStyle.fill,
        ),
        offset = gridToUnit(info.center),
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
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );

    if (widget.start != widget.end) {
      if (widget.pingPong) {
        _controller.repeat();
      } else {
        _controller.forward().whenComplete(widget.whenComplete?.call(widget));
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
        widget.scale = _scale();

        return Stack(
          children: [
            Transform.translate(
              offset: widget.offset,
              child: Transform.scale(
                scale: widget.scale,
                child: widget.cube,
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
        widget.pingPong ? unitPingPong(_controller.value) : _controller.value,
      )!;
}
