import 'dart:ui';

import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/shared/out.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class Cube extends StatefulWidget {
  final GridPoint? center;
  final Crop crop;

  const Cube({
    Key? key,
    this.center,
    required this.crop,
  }) : super(key: key);

  @override
  _CubeState createState() => _CubeState();
}

class _CubeState extends State<Cube> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Offset offset = toOffset(widget.center!);
    // out(offset);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: offset,
          child: Transform.scale(
            scale: _scale(),
            child: widget.crop == Crop.c
                ? const UnitCube()
                : CroppedUnitCube(crop: widget.crop),
          ),
        );
      },
    );
  }

  double _scale() => lerpDouble(0.1, 1, _controller.value)!;
}
