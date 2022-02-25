import 'dart:ui';

import 'package:cube_painter/cubes/full_unit_cube.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

import '../unit_ping_pong.dart';

const noWarn = [out, Slice, UnitToScreen];

//TODO COPy from StaticCubes
// class AnimCubes extends StatelessWidget { }

// TODO rename to AnimCubeFields
class Fields {
  final CubeInfo info;

  final double start;
  final double end;

  final bool pingPong;

  double get scale => _scale;
  double _scale = 1;

  //TODO pass Fields
  final dynamic Function(AnimCube old)? whenComplete;

  final int duration;

  Fields({
    required this.info,
    required this.start,
    required this.end,
    this.pingPong = false,
    this.whenComplete,
    this.duration = 800,
  });
}

class AnimCube extends StatefulWidget {
  final Fields fields;

  final Widget cube;

  final Offset offset;

  AnimCube({
    Key? key,
    required this.fields,
  })  : cube = fields.info.crop == Slice.c
            ? const FullUnitCube()
            : CropUnitCube(crop: fields.info.crop),
        offset = positionToUnitOffset(fields.info.center),
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
      duration: Duration(milliseconds: widget.fields.duration),
      vsync: this,
    );

    if (widget.fields.start != widget.fields.end) {
      if (widget.fields.pingPong) {
        _controller.repeat();
      } else {
        //TODO PASS data into whenComplete()
        _controller
            .forward()
        //TODO pass Fields
            .whenComplete(widget.fields.whenComplete?.call(widget));
        // .whenComplete(widget.data.whenComplete?.call(widget.data));
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
        widget.fields._scale = _scale();

        return Stack(
          children: [
            Transform.translate(
              offset: widget.offset,
              child: Transform.scale(
                scale: widget.fields._scale,
                child: widget.cube,
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
        widget.fields.pingPong
            ? unitPingPong(_controller.value)
            : _controller.value,
      )!;
}
