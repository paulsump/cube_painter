import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:flutter/material.dart';

const noWarn = out;

enum CubeState { brushLine, loading, staticOrGrowing }

/// Manages the starting and stopping of cube animation
/// during loading and brushing.
mixin Animator {
  final animCubeInfos = <CubeInfo>[];

  CubeState cubeState = CubeState.staticOrGrowing;

  /// defined in [Persister]
  Painting get painting;

  /// move all the (static) cubeInfos to animCubeInfos
  /// todo rename to growCubes()
  @protected
  void startAnimatingLoadedCubes() {
    final List<CubeInfo> cubeInfos = painting.cubeInfos;

    animCubeInfos.clear();
    animCubeInfos.addAll(cubeInfos.toList());

    cubeState = CubeState.loading;
  }

  //TODO Rename to startBrushLine
  void startBrushing() {
    finishAnim();

    cubeState = CubeState.brushLine;
  }

  /// Add all the animCubeInfos to the staticCubeInfos,
  /// thus, if there were any cubes still animating,
  /// then they would appear to stop immediately.
  //TODO FIx this copied comment
  /// once the brush has finished, it
  /// yields ownership of it's cubes to this parent widget.
  /// which then creates a similar list
  /// If we are in add gestureMode
  /// the cubes will end up going
  /// in the painting once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubeInfos array once the
  /// anim is done.
  void finishAnim() {
    switch (cubeState) {
      case CubeState.brushLine:
        break;
      case CubeState.loading:
        animCubeInfos.clear();
        break;
      case CubeState.staticOrGrowing:
        painting.cubeInfos.addAll(animCubeInfos);
        animCubeInfos.clear();
        break;
    }
  }
}
