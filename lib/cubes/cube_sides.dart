import 'dart:collection';

import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:flutter/cupertino.dart';

class CubeSide {
  final Color color;
  final Path path;

  const CubeSide(this.color, this.path);
}

List<CubeSide> getCubeSides(Crop crop) {
  final list = getCubeSidesAndUnitOffsets(crop);

  return UnmodifiableListView(
    List.generate(
        list.length,
        (index) => CubeSide(
              getColor(list[index][0]),
              Path()..addPolygon(list[index][1], true),
            )),
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

List<Offset> getUnitOffsetsFromHexagonCornerIndices(List<int> indices) =>
    List<Offset>.generate(
        indices.length, (i) => positionToUnitOffset(_corners[indices[i]]));

List<Offset> calcHexagonOffsets() =>
    // UnmodifiableListView(_calcUnitHexagonUnitOffsets());
    getHexagonCornerOffsets();

List<Offset> getHexagonCornerOffsets() => List<Offset>.generate(
    6, (i) => unit + positionToUnitOffset(_corners[i + 1]));

/// returns polygon offsets in unit coords
/// public for test only
List<List<dynamic>> getCubeSidesAndUnitOffsets(Crop crop) {
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
          getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
        [
          Side.t,
          // /_/
          getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
        [
          Side.br,
          // /|
          // |/
          getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
      ]);
    case Crop.r:
      return UnmodifiableListView([
        [
          Side.t,
          getUnitOffsetsFromHexagonCornerIndices([c, tl, t])
        ],
        [
          Side.bl,
          getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
      ]);
    case Crop.ur:
      return UnmodifiableListView([
        [
          Side.bl,
          getUnitOffsetsFromHexagonCornerIndices([c, b, bl, tl])
        ],
        [
          Side.br,
          getUnitOffsetsFromHexagonCornerIndices([c, br, b])
        ],
      ]);
    case Crop.ul:
      return UnmodifiableListView([
        [
          Side.bl,
          // _|
          getUnitOffsetsFromHexagonCornerIndices([c, b, bl])
        ],
        [
          Side.br,
          // /|
          // |/
          getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
      ]);
    case Crop.l:
      return UnmodifiableListView([
        [
          Side.br,
          getUnitOffsetsFromHexagonCornerIndices([c, tr, br, b])
        ],
        [
          Side.t,
          getUnitOffsetsFromHexagonCornerIndices([c, t, tr])
        ],
      ]);
    case Crop.dl:
      return UnmodifiableListView([
        [
          Side.br,
          // /|
          // |/
          getUnitOffsetsFromHexagonCornerIndices([c, tr, br])
        ],
        [
          Side.t,
          // /_/
          getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
      ]);
    case Crop.dr:
      return UnmodifiableListView([
        [
          Side.bl,
          // |-
          getUnitOffsetsFromHexagonCornerIndices([c, bl, tl])
        ],
        [
          Side.t,
          // /_/
          getUnitOffsetsFromHexagonCornerIndices([c, tl, t, tr])
        ],
      ]);
  }
}
