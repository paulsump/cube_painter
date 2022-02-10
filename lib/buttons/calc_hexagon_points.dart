import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math.dart';

List<Offset> calcHexagonPoints(Offset center, double outerRadius) {
  final points = <Offset>[];

  //TODO TOO HACKY (Lies to API)
  // TODO UPdate tests
  // double radius = 0.75 * outerRadius;
  double radius = outerRadius;

  for (Offset offset in calcUnitHexagonPoints()) {
    //TOOD CHANGe calcUnitHexagonPoints() so it doesn't have to be upside down,
    // thein i can use Transform and const calcUnitHexagonPoints widget
    points.add(offset.scale(radius, radius) + center);
  }
  return points;
}

Iterable<Offset> calcUnitHexagonPoints() sync* {
  const double angle = -pi / 3;
  var vec = Vector2(1, 0);

  vec.postmultiply(Matrix2.rotation(angle / 2));
  yield Offset(vec.x, -vec.y).translate(1, 1);

  for (int i = 0; i < 5; ++i) {
    vec.postmultiply(Matrix2.rotation(angle));
    yield Offset(vec.x, -vec.y).translate(1, 1);
  }
}
