import 'dart:collection';

import 'package:cube_painter/colors.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/cupertino.dart';

const noWarn = out;

/// Used to represent the 3 sides of the 'cube'.
/// Anti clockwise from top right.
/// TODO Rename these to top, bottomLeft and bottomRight
enum Side {
  // 0 top
  t,
  // 1 bottom left
  bl,
  // 2 bottom right
  br
}

/// for painting each side of a cube.
class CubeSide {
  final Side side;

  final Path path;

  const CubeSide(this.side, this.path);

  Paint getPaint(PaintingStyle style) => Paint()
    ..color = getColor(side)
    ..style = style;

  Paint getGradientPaint(PaintingStyle style) {
    // out(_getGradient(side));
    // out(path.getBounds());
    return Paint()
      ..shader = _getGradient(side).createShader(path.getBounds())
      ..style = style;
  }
}

LinearGradient _getGradient(Side side) {
  switch (side) {
    case Side.t:
      return _gradientT;
    case Side.bl:
      return _gradientBL;
    case Side.br:
      return _gradientBR;
  }
}

const double dt = 0.2;
const double t = 0.8;
final _gradientT = LinearGradient(
  colors: [getTweenBLtoTColor(t - dt), getTweenBLtoTColor(t + dt)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

final _gradientBR = LinearGradient(
  colors: [getColor(Side.t), getColor(Side.br)],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

final _gradientBL = LinearGradient(
  colors: [getColor(Side.bl), getColor(Side.t)],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);

UnmodifiableListView<CubeSide> getCubeSides(Slice slice) {
  final list = getCubeSidesAndUnitOffsets(slice);

  return UnmodifiableListView(
    List.generate(list.length, (index) {
      final Side side = list[index][0];

      return CubeSide(side, Path()..addPolygon(list[index][1], true));
    }),
  );
}

const _corners = <Position>[
  Position.zero, // c center
  // anti clockwise from top right
  // /_/|
  // |_|/
  Position(1, 1), // tr
  Position(0, 1), // t
  Position(-1, 0), // tl
  Position(-1, -1), // bl
  Position(0, -1), // b bottom
  Position(1, 0), // br
];

UnmodifiableListView<Offset> _getUnitOffsetsFromHexagonCornerIndices(
        List<int> indices) =>
    UnmodifiableListView(List<Offset>.generate(
        indices.length, (i) => positionToUnitOffset(_corners[indices[i]])));

UnmodifiableListView<Offset> getHexagonCornerOffsets() => UnmodifiableListView(
    List<Offset>.generate(6, (i) => positionToUnitOffset(_corners[i + 1])));

const topSide = [
  Offset(0, 0.0),
  Offset(-root3over2, -0.5),
  Offset(0, -1.0),
  Offset(root3over2, -0.5),
];

const bottomLeftSide = [
  Offset(0, 0.0),
  Offset(0, 1.0),
  Offset(-root3over2, 0.5),
  Offset(-root3over2, -0.5),
];

const bottomRightSide = [
  Offset(0, 0.0),
  Offset(root3over2, -0.5),
  Offset(root3over2, 0.5),
  Offset(0, 1.0),
];

/// returns polygon offsets in unit coords
/// public for test only
UnmodifiableListView<List<dynamic>> getCubeSidesAndUnitOffsets(Slice slice) {
  /// corner indices
  /// anti clockwise
  /// center, top right, top, top left, bottom left, bottom, bottom right.
  const int c = 0, tr = 1, t = 2, tl = 3, bl = 4, b = 5, br = 6;

  switch (slice) {
    case Slice.whole:
      return UnmodifiableListView([
        [
          Side.bl,
          // |_|
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
        [
          Side.t,
          // /_/
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
        [
          Side.br,
          // /|
          // |/
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
      ]);
    case Slice.left:
      return UnmodifiableListView([
        [
          Side.t,
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t])
        ],
        [
          Side.bl,
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
      ]);
    case Slice.bottomLeft:
      return UnmodifiableListView([
        [
          Side.bl,
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
        [
          Side.br,
          _getUnitOffsetsFromHexagonCornerIndices([c, br, b])
        ],
      ]);
    case Slice.bottomRight:
      return UnmodifiableListView([
        [
          Side.bl,
          // _|
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl])
        ],
        [
          Side.br,
          // /|
          // |/
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
      ]);
    case Slice.right:
      return UnmodifiableListView([
        [
          Side.br,
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
        [
          Side.t,
          _getUnitOffsetsFromHexagonCornerIndices([c, t, tr])
        ],
      ]);
    case Slice.topRight:
      return UnmodifiableListView([
        [
          Side.br,
          // /|
          // |/
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br])
        ],
        [
          Side.t,
          // /_/
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
      ]);
    case Slice.topLeft:
      return UnmodifiableListView([
        [
          Side.bl,
          // |-
          _getUnitOffsetsFromHexagonCornerIndices([c, bl, tl])
        ],
        [
          Side.t,
          // /_/
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
      ]);
  }
}
