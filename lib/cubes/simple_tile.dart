import 'dart:ui';

import 'package:cube_painter/cubes/tile.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class SimpleTile extends StatelessWidget {
  final Position bottom;

  final double scale;

  const SimpleTile({
    Key? key,
    required this.bottom,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(bottom);
    final unitOffset = positionToUnitOffset(bottom);
    final double y = -unitOffset.dy;
// out(unitOffset);
    return Transform.translate(
      offset: offset,
      child: Transform.scale(
        scale: scale,
        child: Tile(t: lerpDouble(0.2, 0.9, y / 44)!),
        // child: Tile(t: lerpDouble(0.0, 1, (bottom.x+bottom.y )/ (44+44))!),
      ),
    );
  }
}
