import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math.dart';

List<Offset> calcHexagonPoints() => calcUnitHexagonPoints().toList();

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
