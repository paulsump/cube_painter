import 'package:cube_painter/brush/brush_maths.dart';
import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

/// Turns gestures into a line of cubes or a single slice cube
/// depending on the [GestureMode].
/// In [GestureMode.erase] mode it yields the
/// position you tapped in order to delete a single cube.
class Brush extends StatefulWidget {
  const Brush({Key? key}) : super(key: key);

  @override
  State<Brush> createState() => BrushState();
}

class BrushState extends State<Brush> {
  List<CubeInfo> get _animCubeInfos => getSketchBank(context).animCubeInfos;

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
          _replaceCube(details.localPosition, context);
        }
      },
      onPanEnd: (details) {
        tapped = false;
        _saveForUndo();
      },
      onTapDown: (details) {
        tapped = true;
        _replaceCube(details.localPosition, context);
      },
      onTapUp: (details) {
        tapped = false;
        _saveForUndo();
      },
    );
  }

  void _setPingPong(bool value) {
    final sketchBank = getSketchBank(context);
    sketchBank.setPingPong(value);
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

      // setState(() {});
      _setPingPong(true);
    } else {
      final oldPosition = _animCubeInfos.first.center;

      if (oldPosition != newPosition) {
        _animCubeInfos.clear();

        _addCube(newPosition, slice);
        _setPingPong(true);
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
      // TODO Don't clear to fix  jumpy restarting pingpong
      _animCubeInfos.clear();

      for (Position position in positions.list) {
        CubeInfo? cube = _findAt(position, copy);

        if (cube != null) {
          _animCubeInfos.add(cube);
        } else {
          _addCube(position, Slice.whole);
        }
      }
      _setPingPong(true);
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Slice slice) {
    _animCubeInfos.add(CubeInfo(center: center, slice: slice));
  }

  void _saveForUndo() {
    //TODO _saveForUndo
    _setPingPong(false);
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
