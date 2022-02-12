import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/buttons/hexagon_offsets.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter_test/flutter_test.dart';


const noWarn = out;

void main() {
  const double x = root3over2;
  const double y = 0.5;

  const double delta = 0.00001;

  group('Testing calcHexagonOffsets()', () {
    test('offset 0', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(x, -y) + unit;
      expect(offsets[0].dx, closeTo(offset.dx, delta));
      expect(offsets[0].dy, closeTo(offset.dy, delta));
    });
    test('offset 1', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(0.0, -1.0) + unit;
      expect(offsets[1].dx, closeTo(offset.dx, delta));
      expect(offsets[1].dy, closeTo(offset.dy, delta));
    });
    test('offset 2', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(-x, -y) + unit;
      expect(offsets[2].dx, closeTo(offset.dx, delta));
      expect(offsets[2].dy, closeTo(offset.dy, delta));
    });
    test('offset 3', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(-x, y) + unit;
      expect(offsets[3].dx, closeTo(offset.dx, delta));
      expect(offsets[3].dy, closeTo(offset.dy, delta));
    });
    test('offset 4', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(0.0, 1.0) + unit;
      expect(offsets[4].dx, closeTo(offset.dx, delta));
      expect(offsets[4].dy, closeTo(offset.dy, delta));
    });
    test('offset 5', () {
      final List<Offset> offsets = calcHexagonOffsets();
      final offset = const Offset(x, y) + unit;
      expect(offsets[5].dx, closeTo(offset.dx, delta));
      expect(offsets[5].dy, closeTo(offset.dy, delta));
    });
  });
}
