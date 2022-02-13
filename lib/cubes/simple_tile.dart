import 'package:cube_painter/cubes/tile.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

class SimpleCube extends StatelessWidget {
  final Position bottom;

  const SimpleCube({
    Key? key,
    required this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(bottom);

    return Transform.translate(offset: offset, child: Tile(t: bottom.y / 20));
  }
}
