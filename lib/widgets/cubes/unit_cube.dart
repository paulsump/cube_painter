import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/rendering/colors.dart';
import 'package:cube_painter/rendering/cube_corners.dart';
import 'package:flutter/material.dart';

class UnitCube extends StatelessWidget {
  final bool wire;

  final double opacity;
  final Crop crop;

  const UnitCube({
    Key? key,
    this.wire = false,
    this.opacity = 1,
    this.crop = Crop.c,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _CubePainter(
            context: context,
            colorsAndPaths: _getColorsAndPaths(crop),
            wire: wire,
            opacity: opacity));
  }
}

List<List<dynamic>> _getColorsAndPaths(Crop crop) {
  List<List<dynamic>> lists = [];

  for (final vertAndSide in CubeCorners.getVertsAndSides(crop)) {
    lists.add([
      getColor(vertAndSide[0]),
      Path()..addPolygon(vertAndSide[1], true),
    ]);
  }
  return lists;
}

class _CubePainter extends CustomPainter {
  /// list of [Color,Path]
  final List<List> colorsAndPaths;

  final BuildContext context;
  final bool wire;
  final double opacity;

  const _CubePainter({
    required this.colorsAndPaths,
    required this.context,
    this.wire = false,
    this.opacity = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _draw(canvas, PaintingStyle.stroke);

    if (!wire) {
      _draw(canvas, PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(_CubePainter oldDelegate) => false;

  void _draw(Canvas canvas, PaintingStyle style) {
    for (final colorAndPath in colorsAndPaths) {
      canvas.drawPath(
          colorAndPath[1],
          Paint()
            ..color = colorAndPath[0].withOpacity(opacity)
            ..style = style);
    }
  }
}
