import 'dart:collection';

import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/cupertino.dart';

class CubeSide {
  final Side side;

  final Path path;

  const CubeSide(this.side, this.path);

  Paint getPaint(PaintingStyle style) {
    return Paint()
      ..color = getColor(side)
      ..style = style;
  }

  Paint getGradientPaint(PaintingStyle style) {
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

final _gradientT = LinearGradient(
  colors: [getColor(Side.br), getColor(Side.bl)],
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
);

final _gradientBR = LinearGradient(
  colors: [getColor(Side.t), getColor(Side.br)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final _gradientBL = LinearGradient(
  colors: [getColor(Side.bl), getColor(Side.t)],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);

UnmodifiableListView<CubeSide> getCubeSides(Crop crop) {
  final list = getCubeSidesAndUnitOffsets(crop);

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

// Offset _getUnitOffsetFromHexagonCornerIndex(int index)=>
//      positionToUnitOffset(_corners[index]);

UnmodifiableListView<Offset> _getUnitOffsetsFromHexagonCornerIndices(
        List<int> indices) =>
    UnmodifiableListView(List<Offset>.generate(
        indices.length, (i) => positionToUnitOffset(_corners[indices[i]])));
// indices.length, (i) => _getUnitOffsetFromHexagonCornerIndex(indices[i])));

UnmodifiableListView<Offset> getHexagonCornerOffsets() =>
    UnmodifiableListView(List<Offset>.generate(
        6, (i) => unit + positionToUnitOffset(_corners[i + 1])));

/// returns polygon offsets in unit coords
/// public for test only
UnmodifiableListView<List<dynamic>> getCubeSidesAndUnitOffsets(Crop crop) {
  /// corner indices
  /// anti clockwise
  /// center, top right, top, top left, bottom left, bottom, bottom right.
  const int c = 0, tr = 1, t = 2, tl = 3, bl = 4, b = 5, br = 6;

  switch (crop) {
    case Crop.c:
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
    case Crop.r:
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
    case Crop.ur:
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
    case Crop.ul:
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
    case Crop.l:
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
    case Crop.dl:
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
    case Crop.dr:
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
