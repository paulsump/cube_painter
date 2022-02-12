import 'package:cube_painter/cubes/side.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/grid_point.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:flutter/cupertino.dart';

const _corners = <GridPoint>[
  GridPoint(0, 0), // c center
  // anti clockwise from top right
  // /_/|
  // |_|/
  GridPoint(1, 1), // tr
  GridPoint(0, 1), // t
  GridPoint(-1, 0), // tl
  GridPoint(-1, -1), // bl
  GridPoint(0, -1), // b bottom
  GridPoint(1, 0), // br
];

/// returns polygon points in unit coords
List<List<dynamic>> getCubeSidePoints(Crop crop) {
  /// corner indices
  /// anti clockwise
  /// center, top right, top, top left, bottom left, bottom, bottom right.
  const int c = 0, tr = 1, t = 2, tl = 3, bl = 4, b = 5, br = 6;

  switch (crop) {
    case Crop.c:
      return List.unmodifiable([
        [
          Side.bl,
          // |_|
          _offsets([c, b, bl, tl])
        ],
        [
          Side.t,
          // /_/
          _offsets([c, tl, t, tr])
        ],
        [
          Side.br,
          // /|
          // |/
          _offsets([c, tr, br, b])
        ],
      ]);
    case Crop.r:
      return List.unmodifiable([
        [
          Side.t,
          _offsets([c, tl, t])
        ],
        [
          Side.bl,
          _offsets([c, b, bl, tl])
        ],
      ]);
    case Crop.ur:
      return List.unmodifiable([
        [
          Side.bl,
          _offsets([c, b, bl, tl])
        ],
        [
          Side.br,
          _offsets([c, br, b])
        ],
      ]);
    case Crop.ul:
      return List.unmodifiable([
        [
          Side.bl,
          // _|
          _offsets([c, b, bl])
        ],
        [
          Side.br,
          // /|
          // |/
          _offsets([c, tr, br, b])
        ],
      ]);
    case Crop.l:
      return List.unmodifiable([
        [
          Side.br,
          _offsets([c, tr, br, b])
        ],
        [
          Side.t,
          _offsets([c, t, tr])
        ],
      ]);
    case Crop.dl:
      return List.unmodifiable([
        [
          Side.br,
          // /|
          // |/
          _offsets([c, tr, br])
        ],
        [
          Side.t,
          // /_/
          _offsets([c, tl, t, tr])
        ],
      ]);
    case Crop.dr:
      return List.unmodifiable([
        [
          Side.bl,
          // |-
          _offsets([c, bl, tl])
        ],
        [
          Side.t,
          // /_/
          _offsets([c, tl, t, tr])
        ],
      ]);
  }
}

List<Offset> _offsets(List<int> indices) => List<Offset>.generate(
    indices.length, (i) => gridToUnit(_corners[indices[i]]));
