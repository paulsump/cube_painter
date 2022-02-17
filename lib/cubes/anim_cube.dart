import 'dart:ui';

import 'package:cube_painter/cubes/crop_unit_cube.dart';
import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

import '../unit_ping_pong.dart';

const noWarn = [out, Crop];

// TODO rename to AnimCubeInfo
class Data {
  final CubeInfo info;

  final double start;
  final double end;

  final bool pingPong;

  double get scale => _scale;
  double _scale = 1;

  final dynamic Function(AnimCube old)? whenComplete;
  final int duration;

  Data({
    required this.info,
    required this.start,
    required this.end,
    this.pingPong = false,
    this.whenComplete,
    this.duration = 800,
  });
}

class AnimCube extends StatefulWidget {
  /// This is bad because it's set by the state,
  /// and also  mean this class can't be const
  /// and also causes the warning about
  /// non finals on an @immutable
  // double get scale => _scale;
  // double _scale = 1;
  final Data data;

  final Widget cube;

  final Offset offset;

  AnimCube({
    Key? key,
    required this.data,
  })  : cube = data.info.crop == Crop.c
            ? const FullUnitCube()
            : CropUnitCube(crop: data.info.crop),
        offset = positionToUnitOffset(data.info.center),
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
      duration: Duration(milliseconds: widget.data.duration),
      vsync: this,
    );

    if (widget.data.start != widget.data.end) {
      if (widget.data.pingPong) {
        _controller.repeat();
      } else {
        //TODO PASS data into whenComplete()
        _controller
            .forward()
            .whenComplete(widget.data.whenComplete?.call(widget));
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
        widget.data._scale = _scale();

        return Stack(
          children: [
            Transform.translate(
              offset: widget.offset,
              child: Transform.scale(
                scale: widget.data._scale,
                child: widget.cube,
              ),
            ),
          ],
        );
      },
    );
  }

  double _scale() => lerpDouble(
        widget.data.start,
        widget.data.end,
        widget.data.pingPong
            ? unitPingPong(_controller.value)
            : _controller.value,
      )!;
}
