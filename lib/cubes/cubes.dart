import 'dart:async';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/undoer.dart';
import 'package:flutter/material.dart';

const noWarn = [out];

/// Cube widget store & functionality helper.
/// A place to keep logic for adding cubes that were painted by the user.
/// Handles the undoer.
/// TODO remove this class
class Cubes {
  late void Function(VoidCallback fn) setState;

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
      _addToAnimCubeInfos();
    }));

    undoer = Undoer(context, setState: setState);
  }

  /// once the brush has finished, it
  /// yields ownership of it's cubes to this parent widget.
  /// which then creates a similar list
  /// If we are in add gestureMode
  /// the cubes will end up going
  /// in the sketch once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubeInfos array once the
  /// anim is done.
  // void adopt(List<CubeInfo> orphans) {
  //   setState(() {});
  // }

  void _addToAnimCubeInfos() {
    final sketchBank = getSketchBank(context);

    final List<CubeInfo> cubeInfos = sketchBank.sketch.cubeInfos;

    sketchBank.addAllToAnimCubeInfos(cubeInfos.toList());
    cubeInfos.clear();
  }
}
