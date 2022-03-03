import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:flutter/material.dart';

const noWarn = out;

enum CubeAnimState { brushing, loading, growingOrDone }

/// Manages the starting and stopping of cube animation
/// during loading and brushing.
mixin Animator {
  final animCubeInfos = <CubeInfo>[];

  CubeAnimState cubeState = CubeAnimState.growingOrDone;

  /// defined in [Persister]
  Painting get painting;

  /// move all the (static) cubeInfos to animCubeInfos
  @protected
  void startAnimatingLoadedCubes() {
    final List<CubeInfo> cubeInfos = painting.cubeInfos;

    animCubeInfos.clear();
    animCubeInfos.addAll(cubeInfos.toList());

    cubeState = CubeAnimState.loading;
  }

  void startBrushing() {
    finishAnim();

    cubeState = CubeAnimState.brushing;
  }

  /// Stop animating the cubes by removing them from animCubeInfos
  void finishAnim() {
    switch (cubeState) {
      case CubeAnimState.brushing:
        break;
      case CubeAnimState.loading:

        /// if we were loading then we never removed these from cubeInfos,
        /// so we can throw these away.
        animCubeInfos.clear();
        break;
      case CubeAnimState.growingOrDone:

        /// If the animCubeInfos are newly brushed,
        /// then now they have finished growing so
        /// move them all to the stationary cubeInfos,
        painting.cubeInfos.addAll(animCubeInfos);
        animCubeInfos.clear();
        break;
    }
  }
}
