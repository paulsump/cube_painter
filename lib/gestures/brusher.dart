import 'package:cube_painter/gestures/brush.dart';
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
/// depending on the [Brush].
/// In [Brush.eraseLine] mode it yields the
/// position you tapped in order to delete a single cube.
class Brusher implements GestureHandler {
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
    if (Brush.addSlice != getBrush(context)) {
      _updateLine(point, context);
    } else {
      _replaceCube(point, context);
    }
  }

  @override
  void end(BuildContext context) => _finish(context);

  @override
  void tapDown(Offset point, BuildContext context) {}

  @override
  void tapUp(Offset point, BuildContext context) => _finish(context);

  void _notify(BuildContext context) => getPaintingBank(context).notify();

  void _replaceCube(Offset point, BuildContext context) {
    Slice slice = Slice.whole;

    if (getBrush(context) == Brush.addSlice) {
      slice = Provider.of<BrushNotifier>(context, listen: false).slice;
    }

    final Offset startUnit = screenToUnit(point, context);
    brushMaths.calcStartPosition(startUnit);

    final newPosition = brushMaths.startPosition;
    final animCubes = getAnimCubeInfos(context);

    if (animCubes.isEmpty) {
      _addAnimCube(newPosition, slice, context);

      _notify(context);
    } else {
      final oldPosition = animCubes.first.center;

      if (oldPosition != newPosition) {
        animCubes.clear();

        _addAnimCube(newPosition, slice, context);
        _notify(context);
      }
    }
  }

  void _updateLine(Offset point, BuildContext context) {
    final Positions positions =
        brushMaths.calcPositionsUpToEndPosition(screenToUnit(point, context));

    if (previousPositions != positions) {
      final animCubes = getAnimCubeInfos(context);

      // using order provided by brushMaths
      // only add new anim cubes, deleting any old ones

      var copy = animCubes.toList();
      animCubes.clear();

      for (Position position in positions.list) {
        CubeInfo? cube = _getCubeInfoAt(position, copy);

        if (cube != null) {
          animCubes.add(cube);
        } else {
          _addAnimCube(position, Slice.whole, context);
        }
      }
      _notify(context);
      previousPositions = positions;
    }
  }

  void _addAnimCube(Position center, Slice slice, BuildContext context) =>
      getAnimCubeInfos(context).add(CubeInfo(center: center, slice: slice));

  void _finish(BuildContext context) {
    final bool erase = Brush.eraseLine == getBrush(context);

    final paintingBank = getPaintingBank(context);
    final List<CubeInfo> cubeInfos = paintingBank.painting.cubeInfos;

    if (erase) {
      final foundPositions = <Position>[];

      // for each animCube position
      // add a position if there is a static cubeInfo there
      for (final animCubeInfo in paintingBank.animCubeInfos) {
        final position = animCubeInfo.center;

        if (null != _getCubeInfoAt(position, cubeInfos)) {
          foundPositions.add(position);
        }
      }

      if (foundPositions.isNotEmpty) {
        saveForUndo(context);
      }

      for (final position in foundPositions) {
        // erase most recent first

        for (int i = cubeInfos.length - 1; i >= 0; --i) {
          if (cubeInfos[i].center == position) {
            cubeInfos.removeAt(i);
            break;
          }
        }
      }

      // So that it doesn't get added back in whenComplete()
      paintingBank.animCubeInfos.clear();
    } else {
      saveForUndo(context);
    }
    _notify(context);
    getPaintingBank(context).cubeAnimState = CubeAnimState.growingOrDone;
  }
}

CubeInfo? _getCubeInfoAt(Position position, Iterable<CubeInfo> cubeInfos) {
  for (final info in cubeInfos) {
    if (position == info.center) {
      return info;
    }
  }
  return null;
}
