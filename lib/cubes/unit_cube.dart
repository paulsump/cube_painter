import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_corners.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:flutter/material.dart';

class UnitCube extends StatelessWidget {
  final Crop crop;

  final PaintingStyle style;

  const UnitCube({
    Key? key,
    this.crop = Crop.c,
    this.style = PaintingStyle.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CubePainter(
        context: context,
        colorPathPairs: _getColorsAndPaths(crop),
        style: style,
      ),
    );
  }
}

List<List<dynamic>> _getColorsAndPaths(Crop crop) {
  final list = CubeCorners.getVertsAndSides(crop);

  return List.unmodifiable(
    List.generate(
        list.length,
        (index) => List.unmodifiable([
              getColor(list[index][0]),
              Path()..addPolygon(list[index][1], true),
            ])),
  );
}

class _CubePainter extends CustomPainter {
  /// list of [Color,Path]
  final List<List> colorPathPairs;

  final BuildContext context;

  final PaintingStyle style;

  const _CubePainter({
    required this.colorPathPairs,
    required this.context,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _draw(canvas, style);
  }

  @override
  bool shouldRepaint(_CubePainter oldDelegate) => false;

  void _draw(Canvas canvas, PaintingStyle style) {
    for (final colorPathPair in colorPathPairs) {
      canvas.drawPath(
          colorPathPair[1],
          Paint()
            ..color = colorPathPair[0]
            ..style = style);
    }
  }
}
