import 'dart:ui';
import 'dart:math';

import 'package:cube_painter/out.dart';
import 'package:vector_math/vector_math.dart';

//TODO remove this file
Path calcHexagonPath(Offset center, double radius) {
  out(radius);
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
