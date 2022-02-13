import 'dart:ui';

import 'package:cube_painter/cubes/tile.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class SimpleTile extends StatelessWidget {
  final Position bottom;

  const SimpleTile({
    Key? key,
    required this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(bottom);

    final double y = -offset.dy;
    return Transform.translate(
      offset: offset,
      child: Tile(t: lerpDouble(0.2, 0.9, y / 44)!),
      // child: Tile(t: lerpDouble(0.2, 0.3, y / 44)!),
    );
  }
}