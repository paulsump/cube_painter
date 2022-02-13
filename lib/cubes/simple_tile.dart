import 'package:cube_painter/cubes/unit_tile.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
const noWarn = [out];

class SimpleTile extends StatelessWidget {
  final Offset bottom;

  const SimpleTile({
    Key? key,
    required this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: bottom,
      child: const UnitTile(),
    );
  }
}
