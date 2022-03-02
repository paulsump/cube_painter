import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/gestures/brush_maths.dart';
import 'package:cube_painter/gestures/gesture_handler.dart';
import 'package:cube_painter/gestures/positions.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

/// Turns gestures into a line of cubes or a single slice cube
/// depending on the [GestureMode].
/// In [GestureMode.erase] mode it yields the
/// position you tapped in order to delete a single cube.
class Brush implements GestureHandler {
  //TODO REMOVE THIS FUnk, USE Use sketchBank local
  List<CubeInfo> getAnimCubeInfos(context) =>
      getSketchBank(context).animCubeInfos;

  final brushMaths = BrushMaths();
  var previousPositions = Positions.empty;

  bool tapped = false;

  @override
  void start(Offset point, BuildContext context) {
    getSketchBank(context).startBrushing();

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);
  }

  @override
  void update(Offset point, double scale, BuildContext context) {
    if (GestureMode.addLine == getGestureMode(context)) {
      _updateLine(point, context);
    } else {
      _replaceCube(point, context);
    }
  }

  @override
  void end(BuildContext context) => _saveForUndo(context);

  @override
  void tapDown(Offset point, BuildContext context) {
    getSketchBank(context).startBrushing();

    _replaceCube(point, context);
  }

  @override
  void tapUp(Offset point, BuildContext context) => _saveForUndo(context);

  void _setPingPong(bool value, BuildContext context) =>
      getSketchBank(context).setIsPingPong(value);

  void _replaceCube(Offset point, BuildContext context) {
    Slice slice = Slice.whole;

    if (getGestureMode(context) == GestureMode.addSlice) {
      slice = Provider.of<GestureModeNotifier>(context, listen: false).slice;
    }

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);

    final newPosition = brushMaths.startPosition;

    if (getAnimCubeInfos(context).isEmpty) {
      _addCube(newPosition, slice, context);

      _setPingPong(true, context);
    } else {
      final oldPosition = getAnimCubeInfos(context).first.center;

      if (oldPosition != newPosition) {
        getAnimCubeInfos(context).clear();

        _addCube(newPosition, slice, context);
        _setPingPong(true, context);
      }
    }
  }

  void _updateLine(Offset point, BuildContext context) {
    final Positions positions =
        brushMaths.calcPositionsUpToEndPosition(screenToUnit(point, context));

    if (previousPositions != positions) {
      // using order provided by brushMaths
      // only add new cubes, deleting any old ones

      var copy = getAnimCubeInfos(context).toList();
      getAnimCubeInfos(context).clear();

      for (Position position in positions.list) {
        CubeInfo? cube = _findAt(position, copy);

        if (cube != null) {
          getAnimCubeInfos(context).add(cube);
        } else {
          _addCube(position, Slice.whole, context);
        }
      }
      _setPingPong(true, context);
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Slice slice, BuildContext context) =>
      getAnimCubeInfos(context).add(CubeInfo(center: center, slice: slice));

  void _saveForUndo(BuildContext context) {
    final bool erase = GestureMode.erase == getGestureMode(context);

    final sketchBank = getSketchBank(context);
    final List<CubeInfo> cubeInfos = sketchBank.sketch.cubeInfos;

    if (erase) {
      assert(sketchBank.animCubeInfos.length == 1);

      final orphan = sketchBank.animCubeInfos[0];

      final CubeInfo? cubeInfo = _getCubeInfoAt(orphan.center, cubeInfos);

      if (cubeInfo != null) {
        saveForUndo(context);
        cubeInfos.remove(cubeInfo);
      }

      // So that it doesn't get added back in whenComplete()
      sketchBank.animCubeInfos.clear();
    } else {
      saveForUndo(context);
    }
    _setPingPong(false, context);
    getSketchBank(context).isBrushing = false;
  }

  CubeInfo? _getCubeInfoAt(Position position, List<CubeInfo> cubeInfos) {
    for (final info in cubeInfos) {
      if (position == info.center) {
        return info;
      }
    }
    return null;
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
