import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:flutter/cupertino.dart';

class CubeCorners {
  static const _corners = <GridPoint>[
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
  static List<List<dynamic>> getVertsAndSides(Crop crop) {
    /// corner indices
    /// anti clockwise
    /// center, top right, top, top left, bottom left, bottom, bottom right.
    const int c = 0, tr = 1, t = 2, tl = 3, bl = 4, b = 5, br = 6;

    switch (crop) {
      case Crop.c:
        return [
          [
            Vert.bl,
            // |_|
            _offsets([c, b, bl, tl])
          ],
          [
            Vert.t,
            // /_/
            _offsets([c, tl, t, tr])
          ],
          [
            Vert.br,
            // /|
            // |/
            _offsets([c, tr, br, b])
          ],
        ];
      case Crop.r:
        return [
          [
            Vert.t,
            _offsets([c, tl, t])
          ],
          [
            Vert.bl,
            _offsets([c, b, bl, tl])
          ],
        ];
      case Crop.ur:
        return [
          [
            Vert.bl,
            _offsets([c, b, bl, tl])
          ],
          [
            Vert.br,
            _offsets([c, br, b])
          ],
        ];
      case Crop.ul:
        return [
          [
            Vert.bl,
            // _|
            _offsets([c, b, bl])
          ],
          [
            Vert.br,
            // /|
            // |/
            _offsets([c, tr, br, b])
          ],
        ];
      case Crop.l:
        return [
          [
            Vert.br,
            _offsets([c, tr, br, b])
          ],
          [
            Vert.t,
            _offsets([c, t, tr])
          ],
        ];
      case Crop.dl:
        return [
          [
            Vert.br,
            // /|
            // |/
            _offsets([c, tr, br])
          ],
          [
            Vert.t,
            // /_/
            _offsets([c, tl, t, tr])
          ],
        ];
      case Crop.dr:
        return [
          [
            Vert.bl,
            // |-
            _offsets([c, bl, tl])
          ],
          [
            Vert.t,
            // /_/
            _offsets([c, tl, t, tr])
          ],
        ];
    }
  }

  static List<Offset> _offsets(List<int> indices) => List<Offset>.generate(
      indices.length, (i) => gridToUnit(_corners[indices[i]]));
}
