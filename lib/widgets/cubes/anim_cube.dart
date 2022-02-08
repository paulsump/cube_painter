import 'dart:math';
import 'dart:ui';

import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/widgets/cubes/unit_cube.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Crop];

class AnimCube extends StatefulWidget {
  final CubeInfo info;
  final double start;
  final double end;
  final bool pingPong;

  //TODO reverse for delete
  // final bool direction;

  /// This is bad because it's set by the state,
  /// and also  mean this class can't be const
  /// and also causes the warning about
  /// non finals on an @immutable
  double scale = 1;

  final dynamic Function(AnimCube old)? whenComplete;
  final Widget cube;
  final Offset offset;

  AnimCube({
    Key? key,
    required this.info,
    required this.start,
    required this.end,
    this.pingPong = false,
    this.whenComplete,
  })  : cube = UnitCube(crop: info.crop),
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
        widget.pingPong
            ? (1 + sin(2 * pi * _controller.value) / 2)
            : _controller.value,
      )!;
}
