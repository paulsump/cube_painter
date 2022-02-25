import 'dart:ui';

import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/undoer.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

/// cube widget store & functionality helper
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

    getCubeGroupNotifier(context).init(onSuccessfulLoad: () {
      undoer.clear();
      _addAnimCubes();
    });

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
  /// in the cubeGroup once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubes array once the
  /// anim is done.
  void adopt(List<AnimCube> orphans) {
    final bool erase = GestureMode.erase == getGestureMode(context);

    final cubeGroupNotifier = getCubeGroupNotifier(context);
    final List<CubeInfo> cubeInfos = cubeGroupNotifier.cubeGroup.cubeInfos;

    if (erase) {
      for (final AnimCube cube in orphans) {
        final CubeInfo? cubeInfo =
            _getCubeInfoAt(cube.fields.info.center, cubeInfos);

        if (cubeInfo != null) {
          assert(orphans.length == 1);

          undoer.save();
          cubeInfos.remove(cubeInfo);
        }
      }
    } else {
      undoer.save();
    }

    for (final AnimCube cube in orphans) {
      if (cube.fields.scale == (erase ? 0 : 1)) {
        if (!erase) {
          _convertToStaticCube(cube);
        }
      } else {
        animCubes.add(AnimCube(
          key: UniqueKey(),
          fields: Fields(
            info: cube.fields.info,
            start: cube.fields.scale,
//TODO            Fix extrude leaves in wrong order on simulator       //THEN put back
            end: erase ? 0.0 : 1.0,
            // end: erase ? 0.0 : 0.7,
            whenComplete:
                erase ? _removeSelf : _convertToStaticCubeAndRemoveSelf,
            duration: 222,
          ),
        ));
      }
    }
    setState(() {});
  }

  dynamic _removeSelf(AnimCube old) {
    animCubes.remove(old);
    return () {};
  }

  void _convertToStaticCube(AnimCube old) {
    final notifier = getCubeGroupNotifier(context);

    notifier.addCubeInfo(old.fields.info);
  }

  dynamic _convertToStaticCubeAndRemoveSelf(AnimCube old) {
    _convertToStaticCube(old);
    return _removeSelf(old);
  }

  void _addAnimCubes() {
    final cubeGroupNotifier = getCubeGroupNotifier(context);
    final List<CubeInfo> cubeInfos = cubeGroupNotifier.cubeGroup.cubeInfos;

    animCubes.clear();

    for (int i = 0; i < cubeInfos.length; ++i) {
      animCubes.add(AnimCube(
        key: UniqueKey(),
        fields: Fields(
          info: cubeInfos[i],
          start: unitPingPong((i % 6) / 6) / 2,
          end: 1.0,
          whenComplete: _convertToStaticCubeAndRemoveSelf,
        ),
      ));
    }

    cubeGroupNotifier.clear();
    setState(() {});
  }
}
