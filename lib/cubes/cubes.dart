import 'dart:async';

import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/undoer.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

/// Cube widget store & functionality helper.
/// A place to keep logic for adding cubes that were painted by the user.
/// Handles the undoer.
/// TODO remove this class, it will disappear if i use ScaledCubes instead of AnimCubes.
class Cubes {
  late void Function(VoidCallback fn) setState;

  final List<AnimCube> animCubes = [];

  late Undoer undoer;
  late BuildContext context;

  void init({
    required void Function(VoidCallback fn) setState_,
    required BuildContext context_,
  }) {
    setState = setState_;
    context = context_;

    unawaited(getSketchBank(context).init(onSuccessfulLoad: () {
      undoer.clear();
      _addAnimCubes();
    }));

    undoer = Undoer(context, setState: setState);
  }

  CubeInfo? _getCubeInfoAt(Position position, List<CubeInfo> cubeInfos) {
    for (final info in cubeInfos) {
      if (position == info.center) {
        return info;
      }
    }
    return null;
  }

  /// once the brush has finished, it
  /// yields ownership of it's cubes to this parent widget.
  /// which then creates a similar list
  /// If we are in add gestureMode
  /// the cubes will end up going
  /// in the sketch once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubes array once the
  /// anim is done.
  void adopt(List<CubeInfo> orphans) {
    getSketchBank(context).setPlaying(true);
    final bool erase = GestureMode.erase == getGestureMode(context);

    final sketchBank = getSketchBank(context);
    final List<CubeInfo> cubeInfos = sketchBank.sketch.cubeInfos;

    if (erase) {
      for (final CubeInfo orphan in orphans) {
        final CubeInfo? cubeInfo = _getCubeInfoAt(orphan.center, cubeInfos);

        if (cubeInfo != null) {
          assert(orphans.length == 1);

          undoer.save();
          cubeInfos.remove(cubeInfo);
        }
      }
    } else {
      undoer.save();
    }

    for (final CubeInfo orphan in orphans) {
      // if (orphan.scale == (erase ? 0 : 1)) {
      //  if (!erase) {
      //    _convertToStaticCube(orphan);
      //  }
      animCubes.add(AnimCube(
        key: UniqueKey(),
        fields: Fields(
          info: orphan,
          // start: orphan.scale,
          start: !erase ? 0.0 : 1.0,
          end: erase ? 0.0 : 1.0,
          // end: erase ? 0.0 : 0.7,
          whenComplete: erase ? _removeSelf : _convertToStaticCubeAndRemoveSelf,
          milliseconds: 222,
        ),
      ));
    }
    setState(() {});
  }

  dynamic _removeSelf(AnimCube old) {
    animCubes.remove(old);
    return () {};
  }

  void _convertToStaticCube(AnimCube old) {
    final sketchBank = getSketchBank(context);

    sketchBank.addCubeInfo(old.fields.info);
  }

  dynamic _convertToStaticCubeAndRemoveSelf(AnimCube old) {
    _convertToStaticCube(old);
    return _removeSelf(old);
  }

  void _addAnimCubes() {
    // return;
    final sketchBank = getSketchBank(context);
    final List<CubeInfo> cubeInfos = sketchBank.sketch.cubeInfos;

    animCubes.clear();

    for (int i = 0; i < cubeInfos.length; ++i) {
      animCubes.add(AnimCube(
        key: UniqueKey(),
        fields: Fields(
          info: cubeInfos[i],
          start: unitPingPong((i % 6) / 6) / 2,
          // end: 1.0,
          // HACK FOR testing
          end: 0.1,
          whenComplete: _convertToStaticCubeAndRemoveSelf,
        ),
      ));
    }

    sketchBank.clear();
    setState(() {});
  }
}
