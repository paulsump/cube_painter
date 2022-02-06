import 'dart:ui';

import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class Cube extends StatefulWidget {
  final GridPoint center;

  final Crop crop;
  final bool start;

  const Cube({
    Key? key,
    required this.center,
    required this.crop,
    required this.start,
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
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    if (widget.start) {
      _controller.forward();
    }

    offset = toOffset(widget.center);
    cube = widget.crop == Crop.c
        ? const UnitCube()
        : CroppedUnitCube(crop: widget.crop);

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
        return Transform.translate(
          offset: offset,
          child: Transform.scale(
            scale: _scale(),
            child: cube,
          ),
        );
      },
    );
  }

  double _scale() => lerpDouble(0.7, 1, _controller.value)!;
}
