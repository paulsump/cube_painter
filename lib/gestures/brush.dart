import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/gestures/brush_maths.dart';
import 'package:cube_painter/gestures/gesture_handler.dart';
import 'package:cube_painter/gestures/positions.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

/// Turns gestures into a line of cubes or a single slice cube
/// depending on the [GestureMode].
/// In [GestureMode.brushErase] mode it yields the
/// position you tapped in order to delete a single cube.
class Brush implements GestureHandler {
  List<CubeInfo> getAnimCubeInfos(context) =>
      getPaintingBank(context).animCubeInfos;

  final brushMaths = BrushMaths();
  var previousPositions = Positions.empty;

  bool tapped = false;

  @override
  void start(Offset point, BuildContext context) {
    getPaintingBank(context).startBrushing();

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);
  }

  @override
  void update(Offset point, double scale, BuildContext context) {
    if (GestureMode.addSlice != getGestureMode(context)) {
      _updateLine(point, context);
    } else {
      _replaceCube(point, context);
    }
  }

  @override
  void end(BuildContext context) => _saveForUndo(context);

  @override
  void tapDown(Offset point, BuildContext context) {
    getPaintingBank(context).startBrushing();

    _replaceCube(point, context);
  }

  @override
  void tapUp(Offset point, BuildContext context) => _saveForUndo(context);

  void _notify(BuildContext context) => getPaintingBank(context).notify();

  void _replaceCube(Offset point, BuildContext context) {
    Slice slice = Slice.whole;

    if (getGestureMode(context) == GestureMode.addSlice) {
      slice = Provider.of<GestureModeNotifier>(context, listen: false).slice;
    }

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);

    final newPosition = brushMaths.startPosition;
    final animCubes = getAnimCubeInfos(context);

    if (animCubes.isEmpty) {
      _addCube(newPosition, slice, context);

      _notify(context);
    } else {
      final oldPosition = animCubes.first.center;

      if (oldPosition != newPosition) {
        animCubes.clear();

        _addCube(newPosition, slice, context);
        _notify(context);
      }
    }
  }

  void _updateLine(Offset point, BuildContext context) {
    final Positions positions =
        brushMaths.calcPositionsUpToEndPosition(screenToUnit(point, context));

    if (previousPositions != positions) {
      // using order provided by brushMaths
      // only add new cubes, deleting any old ones

      final animCubes = getAnimCubeInfos(context);
      var copy = animCubes.toList();
      animCubes.clear();

      for (Position position in positions.list) {
        CubeInfo? cube = _findAt(position, copy);

        if (cube != null) {
          animCubes.add(cube);
        } else {
          _addCube(position, Slice.whole, context);
        }
      }
      _notify(context);
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Slice slice, BuildContext context) =>
      getAnimCubeInfos(context).add(CubeInfo(center: center, slice: slice));

  void _saveForUndo(BuildContext context) {
    final bool erase = GestureMode.brushErase == getGestureMode(context);

    final paintingBank = getPaintingBank(context);
    final List<CubeInfo> cubeInfos = paintingBank.painting.cubeInfos;

    if (erase) {
      final found = <CubeInfo>[];

      for (final animCubeInfo in paintingBank.animCubeInfos) {
        final CubeInfo? cubeInfo =
            _getCubeInfoAt(animCubeInfo.center, cubeInfos);

        if (cubeInfo != null) {
          found.add(cubeInfo);
        }
      }

      if (found.isNotEmpty) {
        saveForUndo(context);
      }

      for (final f in found) {
        cubeInfos.remove(f);
      }

      // So that it doesn't get added back in whenComplete()
      paintingBank.animCubeInfos.clear();
    } else {
      saveForUndo(context);
    }
    _notify(context);
    getPaintingBank(context).cubeState = CubeState.growingOrDone;
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
