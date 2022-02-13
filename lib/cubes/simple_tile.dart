import 'dart:ui';

import 'package:cube_painter/cubes/unit_tile.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class SimpleTile extends StatelessWidget {
  final Position bottom;

  final double t;

  const SimpleTile({
    Key? key,
    required this.bottom,
    required this.t,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = positionToUnitOffset(bottom);

    return Transform.translate(
      offset: offset,
      child: UnitTile(t: t),
    );
  }
}
