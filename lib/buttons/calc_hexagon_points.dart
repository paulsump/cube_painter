import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math.dart';

List<Offset> calcHexagonPoints(Offset center, double radius) {
  final points = <Offset>[];

  for (Offset offset in calcUnitHexagonPoints()) {
    points.add(offset.scale(radius, -radius) + center);
  }
  return points;
}

Iterable<Offset> calcUnitHexagonPoints() sync* {
  const double angle = -pi / 3;
  var vec = Vector2(1, 0);

  vec.postmultiply(Matrix2.rotation(angle / 2));
  yield Offset(vec.x, vec.y);

  for (int i = 0; i < 5; ++i) {
    vec.postmultiply(Matrix2.rotation(angle));
    yield Offset(vec.x, vec.y);
  }
}
