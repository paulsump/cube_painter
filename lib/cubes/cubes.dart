import 'dart:ui';

import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/undoer.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const noWarn = [
  out,
  getScreen,
  lerpDouble,
  positionToUnitOffset,
];

/// cube widget store & functionality helper
class Cubes {
  late void Function(VoidCallback fn) setState;

  final List<AnimCube> animCubes = [];
  final List<SimpleCube> simpleCubes = [];

  late Undoer undoer;
  late BuildContext context;

  void init({
    required void Function(VoidCallback fn) setState_,
    required BuildContext context_,
  }) {
    setState = setState_;
    context = context_;

    getCubeGroupNotifier(context).init(folderPath: 'data', addCubes: _addCubes);
    undoer = Undoer(simpleCubes, setState: setState);
  }

  /// once the brush has finished, it
  /// yields ownership of it's cubes to this parent widget.
  /// which then creates a similar list
  /// If we are in add gestureMode
  /// the cubes will end up going
  /// in the simpleCube list once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubes array once the
  /// anim is done.
  void adopt(List<AnimCube> orphans) {
    final bool erase = GestureMode.erase == getGestureMode(context);

    if (erase) {
      for (final AnimCube cube in orphans) {
        final SimpleCube? simpleCube = _getCubeAt(cube.info.center);

        if (simpleCube != null) {
          assert(orphans.length == 1);

          undoer.save();
          simpleCubes.remove(simpleCube);
        }
      }
    } else {
      undoer.save();
    }

    for (final AnimCube cube in orphans) {
      if (cube.scale == (erase ? 0 : 1)) {
        if (!erase) {
          simpleCubes.add(SimpleCube(info: cube.info));
        }
      } else {
        animCubes.add(AnimCube(
          key: UniqueKey(),
          info: cube.info,
          start: cube.scale,
          end: erase ? 0.0 : 1.0,
          whenComplete: erase ? _removeSelf : _convertToSimpleCubeAndRemoveSelf,
          duration: 222,
        ));
      }
    }
    setState(() {});
  }

  dynamic _removeSelf(AnimCube old) {
    animCubes.remove(old);
    return () {};
  }

  dynamic _convertToSimpleCubeAndRemoveSelf(AnimCube old) {
    simpleCubes.add(SimpleCube(info: old.info));
    return _removeSelf(old);
  }

  SimpleCube? _getCubeAt(Position position) {
    for (final cube in simpleCubes) {
      if (position == cube.info.center) {
        return cube;
      }
    }
    return null;
  }

  void _addCubes() {
    List<CubeInfo> cubeInfos = getCubeInfos(context);

    simpleCubes.clear();
    animCubes.clear();

    for (int i = 0; i < cubeInfos.length; ++i) {
      animCubes.add(AnimCube(
        key: UniqueKey(),
        info: cubeInfos[i],
        start: unitPingPong((i % 6) / 6) / 2,
        end: 1.0,
        whenComplete: _convertToSimpleCubeAndRemoveSelf,
      ));
    }

    setState(() {});
  }

  void saveToClipboard() {
    final notifier = getCubeGroupNotifier(context);

    notifier.cubeGroup = CubeGroup(
        List.generate(simpleCubes.length, (i) => simpleCubes[i].info));

    Clipboard.setData(ClipboardData(text: notifier.json));
  }
}