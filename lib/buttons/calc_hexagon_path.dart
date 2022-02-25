import 'dart:math';
import 'dart:ui';

import 'package:cube_painter/out.dart';
import 'package:vector_math/vector_math.dart';

const noWarn = out;

//TODO remove this file and use getHexagonCornerOffsets() instead
Path calcHexagonPath(Offset center, double radius) {
  final points = <Offset>[];

  for (Offset offset in _hexagonPoints()) {
    points.add(offset * radius + center);
  }
  return Path()..addPolygon(points, true);
}

Iterable<Offset> _hexagonPoints() sync* {
  const double angle = pi / 3;
  var vec = Vector2(1, 0);

  vec.postmultiply(Matrix2.rotation(angle / 2));

  for (int i = 0; i < 6; ++i) {
    vec.postmultiply(Matrix2.rotation(angle));

    yield Offset(vec.x, vec.y);
  }
}
