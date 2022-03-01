import 'package:cube_painter/brush/brush_maths.dart';
import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

/// Turns gestures into a line of cubes or a single slice cube
/// depending on the [GestureMode].
/// In [GestureMode.erase] mode it yields the
/// position you tapped in order to delete a single cube.
class Brush extends StatefulWidget {
  final _cubeInfos = <CubeInfo>[];

  Brush({Key? key}) : super(key: key);

  @override
  State<Brush> createState() => BrushState();
}

class BrushState extends State<Brush> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<CubeInfo> get _animCubeInfos => getSketchBank(context).animCubeInfos;
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    for (int i = 0; i < widget._cubeInfos.length; ++i)
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
            _handOver();
          },
          onTapDown: (details) {
            tapped = true;
            _replaceCube(details.localPosition, context);
          },
          onTapUp: (details) {
            tapped = false;
            _handOver();
          },
        );
      },
    );
  }

  /// Where the positions of the cubes are given away
  void _handOver() {
    final sketchBank = getSketchBank(context);
    sketchBank.addAllToAnimCubeInfos(widget._cubeInfos);
    if (widget._cubeInfos.isNotEmpty) {
      sketchBank.addAllToAnimCubeInfos(widget._cubeInfos.toList());
      widget._cubeInfos.clear();
      //TODO UNDO
    }
  }

  void _replaceCube(Offset point, BuildContext context) {
    Slice slice = Slice.whole;

    if (getGestureMode(context) == GestureMode.addSlice) {
      slice = Provider.of<GestureModeNotifier>(context, listen: false).slice;
    }

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);

    final newPosition = brushMaths.startPosition;

    if (_animCubeInfos.isEmpty) {
      _addCube(newPosition, slice);

      setState(() {});
      _handOver();
    } else {
      final oldPosition = _animCubeInfos.first.center;

      if (oldPosition != newPosition) {
        _animCubeInfos.clear();

        // TODO fix jump in animation due to not passing current _controller value through
        _addCube(newPosition, slice);
        setState(() {});
        _handOver();
      }
    }
  }

  void _updateExtrude(details, BuildContext context) {
    final Positions positions = brushMaths.calcPositionsUpToEndPosition(
        screenToUnit(details.localPosition, context));

    if (previousPositions != positions) {
      // using order provided by extruder
      // only add new cubes, deleting any old ones

      var copy = _animCubeInfos.toList();
      _animCubeInfos.clear();

      for (Position position in positions.list) {
        CubeInfo? cube = _findAt(position, copy);

        if (cube != null) {
          _animCubeInfos.add(cube);
        } else {
          _addCube(position, Slice.whole);
        }
      }
      setState(() {});
      _handOver();
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Slice slice) {
    _animCubeInfos.add(CubeInfo(center: center, slice: slice));
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
