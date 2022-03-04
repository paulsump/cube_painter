import 'dart:ui';

import 'package:cube_painter/cubes/calc_unit_ping_pong.dart';
import 'package:cube_painter/cubes/slice_unit_cube.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/whole_unit_cube.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// Auto generated (painted) thumbnail of a [Painting]
/// Used on the buttons on the [PaintingsMenu]
/// 'Unit' means this thumbnail has size of 1
class Thumbnail extends StatelessWidget {
  final Painting painting;

  final UnitTransform _unitTransform;
  final bool isPingPong;

  const Thumbnail({
    Key? key,
    required this.painting,
    required UnitTransform unitTransform,
    required this.isPingPong,
  })  : _unitTransform = unitTransform,
        super(key: key);

  Thumbnail.useTransform({Key? key, required Painting painting})
      : this(
          key: key,
          painting: painting,
          unitTransform: painting.unitTransform,
          isPingPong: false,
        );

  @override
  Widget build(BuildContext context) {
    return painting.cubeInfos.isNotEmpty
        ? Transform.scale(
            scale: _unitTransform.scale,
            child: Transform.translate(
                offset: _unitTransform.offset,
                child: isPingPong

                    /// Note that this only animates the first cube.
                    /// That's all that's needed currently.
                    ? _StandAloneAnimatedCube(info: painting.cubeInfos[0])
                    : StaticCubes(painting: painting)),
          )
        : Container();
  }
}

/// Unit cube or slice that animates itself based the fields passed in.
/// Used on the [_SlicesExamplePainting] only now that I have [GrowingCubes] and [BrushCubes]
class _StandAloneAnimatedCube extends StatefulWidget {
  final CubeInfo info;

  final double start;
  final double end;

  final bool isPingPong;

  final int milliseconds;

  final Widget _unitCube;

  final Offset _offset;

  _StandAloneAnimatedCube({
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

class _StandAloneAnimatedCubeState extends State<_StandAloneAnimatedCube>
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
