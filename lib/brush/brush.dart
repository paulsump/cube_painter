import 'package:cube_painter/brush/brush_maths.dart';
import 'package:cube_painter/brush/gesture_handler.dart';
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
class Brush implements GestureHandler {
  List<CubeInfo> getAnimCubeInfos(context) =>
      getSketchBank(context).animCubeInfos;

  final brushMaths = BrushMaths();
  var previousPositions = Positions.empty;

  bool tapped = false;

  @override
  void start(Offset point, BuildContext context) {
    getSketchBank(context).addAllAnimCubeInfosToStaticCubeInfos();

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);
  }

  @override
  void update(Offset point, double scale, BuildContext context) {
    if (GestureMode.addWhole == getGestureMode(context)) {
      _updateExtrude(point, context);
    } else {
      _replaceCube(point, context);
    }
  }

  @override
  void end(BuildContext context) {
    _saveForUndo(context);
  }

  @override
  void tapDown(Offset point, BuildContext context) {
    getSketchBank(context).addAllAnimCubeInfosToStaticCubeInfos();

    _replaceCube(point, context);
  }

  @override
  void tapUp(Offset point, BuildContext context) {
    _saveForUndo(context);
  }

  void _setPingPong(bool value, BuildContext context) {
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

    if (getAnimCubeInfos(context).isEmpty) {
      _addCube(newPosition, slice, context);

      // setState(() {});
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

  void _updateExtrude(Offset point, BuildContext context) {
    final Positions positions =
        brushMaths.calcPositionsUpToEndPosition(screenToUnit(point, context));

    if (previousPositions != positions) {
      // using order provided by extruder
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

  void _addCube(Position center, Slice slice, BuildContext context) {
    getAnimCubeInfos(context).add(CubeInfo(center: center, slice: slice));
  }

  void _saveForUndo(BuildContext context) {
//warning, need to call this:    getSketchBank(context).addAllAnimCubeInfosToStaticCubeInfos();
//before this..
    //TODO _saveForUndo
    _setPingPong(false, context);
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
