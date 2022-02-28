import 'package:cube_painter/brush/brush_maths.dart';
import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

/// Turns gestures into a line of cubes or a single slice cube
/// depending on the [GestureMode].  In [GestureMode.erase] mode it yields the
/// position you tapped in order to delete a single cube.
class Brush extends StatefulWidget {
  final _cubeInfos = <CubeInfo>[];

  final void Function(List<CubeInfo> orphans) adoptCubes;

  Brush({Key? key, required this.adoptCubes}) : super(key: key);

  /// This is called by the [BrushState].
  /// It's where the positions of the cubes are given away
  /// to the [Cubes] calling class via a callback [adoptCubes]
  void _handOver() {
    if (_cubeInfos.isNotEmpty) {
      final orphans = _cubeInfos.toList();

      _cubeInfos.clear();
      adoptCubes(orphans);
    }
  }

  @override
  State<Brush> createState() => BrushState();
}

class BrushState extends State<Brush> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final brushMaths = BrushMaths();
  var previousPositions = Positions.empty;

  bool tapped = false;
  final double start = 0.0;

  double get end => GestureMode.addWhole == getGestureMode(context) ? 1.0 : 3.0;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int n = widget._cubeInfos.length;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // HACK without this container,
              // onPanStart etc doesn't get called after cubes are added.
              Container(),
              UnitToScreen(
                child: Stack(
                  children: [
                    for (int i = 0; i < n; ++i)
                      ScaledCube(
                          scale: pingPongBetween(
                              start, end, _controller.value + 1 * i / n),
                          info: widget._cubeInfos[i]),
                  ],
                ),
              ),
            ],
          ),
          onPanStart: (details) {
            // if tapped, use that fromPosition since it's where the user started, and therefore better
            if (!tapped) {
              final Offset startUnit =
              screenToUnit(details.localPosition, context);
              brushMaths.calcStartPosition(startUnit);
            }
          },
          onPanUpdate: (details) {
            if (GestureMode.addWhole == getGestureMode(context)) {
              _updateExtrude(details, context);
            } else {
              _replaceCube(details.localPosition, context);
            }
          },
          onPanEnd: (details) {
            tapped = false;
            widget._handOver();
          },
          onTapDown: (details) {
            tapped = true;
            _replaceCube(details.localPosition, context);
          },
          onTapUp: (details) {
            tapped = false;
            widget._handOver();
          },
        );
      },
    );
  }

  void _replaceCube(Offset point, BuildContext context) {
    Slice slice = Slice.whole;

    if (getGestureMode(context) == GestureMode.addSlice) {
      slice = Provider.of<GestureModeNotifier>(context, listen: false).slice;
    }

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);

    final newPosition = brushMaths.startPosition;

    if (widget._cubeInfos.isEmpty) {
      _addCube(newPosition, slice);

      setState(() {});
    } else {
      final oldPosition = widget._cubeInfos.first.center;

      if (oldPosition != newPosition) {
        widget._cubeInfos.clear();

        // TODO fix jump in animation due to not passing current _controller value through
        _addCube(newPosition, slice);
        setState(() {});
      }
    }
  }

  void _updateExtrude(details, BuildContext context) {
    final Positions positions = brushMaths.calcPositionsUpToEndPosition(
        screenToUnit(details.localPosition, context));

    if (previousPositions != positions) {
      // using order provided by extruder
      // only add new cubes, deleting any old ones

      var copy = widget._cubeInfos.toList();
      widget._cubeInfos.clear();

      for (Position position in positions.list) {
        CubeInfo? cube = _findAt(position, copy);

        if (cube != null) {
          widget._cubeInfos.add(cube);
        } else {
          _addCube(position, Slice.whole);
        }
      }
      setState(() {});
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Slice slice) {
    widget._cubeInfos.add(CubeInfo(center: center, slice: slice));
  }
}

CubeInfo? _findAt(Position position, List<CubeInfo> list) {
  for (final info in list) {
    if (position == info.center) {
      return info;
    }
  }
  return null;
}
