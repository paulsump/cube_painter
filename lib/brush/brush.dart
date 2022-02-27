import 'package:cube_painter/brush/brush_maths.dart';
import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

class Brush extends StatefulWidget {
  final _animCubes = <AnimCube>[];

  final void Function(List<AnimCube> orphans) adoptCubes;

  Brush({Key? key, required this.adoptCubes}) : super(key: key);

  void _handOver() {
    if (_animCubes.isNotEmpty) {
      final orphans = _animCubes.toList();

      _animCubes.clear();
      adoptCubes(orphans);
    }
  }

  @override
  State<Brush> createState() => BrushState();
}

class BrushState extends State<Brush> {
  final brushMaths = BrushMaths();

  var previousPositions = Positions.empty;
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          // HACK without this container,
          // onPanStart etc doesn't get called after cubes are added.
          Container(),
          UnitToScreen(child: Stack(children: widget._animCubes)),
        ],
      ),
      onPanStart: (details) {
        // if tapped, use that fromPosition since it's where the user started, and therefore better
        if (!tapped) {
          final Offset startUnit = screenToUnit(details.localPosition, context);
          brushMaths.calcStartPosition(startUnit);
        }
      },
      onPanUpdate: (details) {
        if (GestureMode.addWhole == getGestureMode(context)) {
          _updateExtrude(details, context);
        } else {
          _addOrMoveCube(details.localPosition, context);
        }
      },
      onPanEnd: (details) {
        tapped = false;
        widget._handOver();
      },
      onTapDown: (details) {
        tapped = true;
        _addOrMoveCube(details.localPosition, context);
      },
      onTapUp: (details) {
        tapped = false;
        widget._handOver();
      },
    );
  }

  void _addOrMoveCube(Offset point, BuildContext context) {
    Slice slice = Slice.whole;

    if (getGestureMode(context) == GestureMode.addSlice) {
      slice = Provider.of<GestureModeNotifier>(context, listen: false).slice;
    }

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);

    final newPosition = brushMaths.startPosition;

    if (widget._animCubes.isEmpty) {
      _addCube(newPosition, slice);

      setState(() {});
    } else {
      final oldPosition = widget._animCubes.first.fields.info.center;

      if (oldPosition != newPosition) {
        widget._animCubes.first.offset = positionToUnitOffset(newPosition);
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

      var copy = widget._animCubes.toList();
      widget._animCubes.clear();

      for (Position position in positions.list) {
        AnimCube? cube = _findAt(position, copy);

        if (cube != null) {
          widget._animCubes.add(cube);
        } else {
          _addCube(position, Slice.whole);
        }
      }
      setState(() {});
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Slice slice) {
    widget._animCubes.add(AnimCube(
        key: UniqueKey(),
        fields: Fields(
          info: CubeInfo(center: center, slice: slice),
          start: 0.0,
          end: getGestureMode(context) == GestureMode.addWhole ? 1.0 : 3.0,
          pingPong: true,
        )));
  }
}

AnimCube? _findAt(Position position, List<AnimCube> list) {
  for (final cube in list) {
    if (position == cube.fields.info.center) {
      return cube;
    }
  }
  return null;
}
