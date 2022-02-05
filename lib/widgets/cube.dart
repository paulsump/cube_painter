import 'package:cube_painter/shared/cube_corners.dart';
import 'package:cube_painter/shared/colors.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:flutter/material.dart';

class Cube extends StatelessWidget {
  // final Crop crop;

  const Cube({
    Key? key,
    // required this.crop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CubePainter(
        context: context,
        colorsAndPaths: getColorsAndPaths(),
      ),
    );
  }
}

List<List<dynamic>> getColorsAndPaths() {
  List<List<dynamic>> lists = [];

  for (final vertAndSide in CubeCorners.getVertsAndSides(Crop.c,Offset.zero)) {
    lists.add(
      [
        getColor(vertAndSide[0]),
        Path()..addPolygon(vertAndSide[1], true),
      ],
    );
  }
  return lists;
}

class _CubePainter extends CustomPainter {
  /// list of [Color,Path]
  final List<List> colorsAndPaths;

  static const styles = [PaintingStyle.stroke, PaintingStyle.fill];
  final BuildContext context;

  const _CubePainter({required this.colorsAndPaths, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    // clipAndZoom(canvas, context);

    for (final style in styles) {
      for (final colorAndPath in colorsAndPaths) {
        canvas.drawPath(
            colorAndPath[1],
            Paint()
              ..color = colorAndPath[0]
              ..style = style);
      }
    }
  }

  @override
  bool shouldRepaint(_CubePainter oldDelegate) => false;
}
