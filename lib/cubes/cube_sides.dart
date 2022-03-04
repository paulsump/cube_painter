import 'dart:collection';

import 'package:cube_painter/colors.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/cupertino.dart';

const noWarn = out;

/// Used to represent the 3 sides of the 'cube'.
enum Side { top, bottomLeft, bottomRight }

/// Paint and path for painting a side of a cube.
/// TODO Optimise this away with caches, by replacing getColor()
class CubeSide {
  final Side side;

  final Path path;

  const CubeSide({required this.side, required this.path});

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

Color getColor(Side side) {
  switch (side) {
    case Side.bottomRight:
      return bottomRightColor; // Light
    case Side.top:
      return topColor; // Medium
    case Side.bottomLeft:
      return bottomLeftColor; // Dark
  }
}

LinearGradient _getGradient(Side side) {
  switch (side) {
    case Side.top:
      return _gradientT;
    case Side.bottomLeft:
      return _gradientBL;
    case Side.bottomRight:
      return _gradientBR;
  }
}

//TODO inline these, making more consts
// either that or rename them
const double _dt = 0.2;
const double _t = 0.8;
final _gradientT = LinearGradient(
  colors: [getTweenBLtoTColor(_t - _dt), getTweenBLtoTColor(_t + _dt)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const _gradientBR = LinearGradient(
  colors: [topColor, bottomRightColor],
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
);

const _gradientBL = LinearGradient(
  colors: [bottomLeftColor, topColor],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);

/// returns a list of [CubeSide]s for painting a cube or various types of [Slice]
UnmodifiableListView<CubeSide> getCubeSides(Slice slice) {
  final list = getCubeSidesAndUnitOffsets(slice);

  return UnmodifiableListView(
    list.map(
      (sideAndUnitOffset) => CubeSide(
        side: sideAndUnitOffset[0],
        path: Path()..addPolygon(sideAndUnitOffset[1], true),
      ),
    ),
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
    UnmodifiableListView(
      indices.map((index) => positionToUnitOffset(_corners[index])),
    );

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
          Side.bottomLeft,
          // |_|
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
        [
          Side.top,
          // /_/
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
        [
          Side.bottomRight,
          // /|
          // |/
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
      ]);
    case Slice.left:
      return UnmodifiableListView([
        [
          Side.top,
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t])
        ],
        [
          Side.bottomLeft,
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
      ]);
    case Slice.bottomLeft:
      return UnmodifiableListView([
        [
          Side.bottomLeft,
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
        [
          Side.bottomRight,
          _getUnitOffsetsFromHexagonCornerIndices([c, br, b])
        ],
      ]);
    case Slice.bottomRight:
      return UnmodifiableListView([
        [
          Side.bottomLeft,
          // _|
          _getUnitOffsetsFromHexagonCornerIndices([c, b, bl])
        ],
        [
          Side.bottomRight,
          // /|
          // |/
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
      ]);
    case Slice.right:
      return UnmodifiableListView([
        [
          Side.bottomRight,
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
        [
          Side.top,
          _getUnitOffsetsFromHexagonCornerIndices([c, t, tr])
        ],
      ]);
    case Slice.topRight:
      return UnmodifiableListView([
        [
          Side.bottomRight,
          // /|
          // |/
          _getUnitOffsetsFromHexagonCornerIndices([c, tr, br])
        ],
        [
          Side.top,
          // /_/
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
      ]);
    case Slice.topLeft:
      return UnmodifiableListView([
        [
          Side.bottomLeft,
          // |-
          _getUnitOffsetsFromHexagonCornerIndices([c, bl, tl])
        ],
        [
          Side.top,
          // /_/
          _getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
      ]);
  }
}
