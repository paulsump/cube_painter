import 'package:cube_painter/cubes/unit_tile.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

class SimpleTile extends StatelessWidget {
  final Offset bottom;

  final double scale;

  const SimpleTile({
    Key? key,
    required this.bottom,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: bottom,
      child: Transform.scale(
        scale: scale,
        child: const UnitTile(),
      ),
    );
  }
}
