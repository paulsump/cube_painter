import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// The various states used to control
/// how the cubes animate
/// either after loading or brushing
/// or during a brush.
enum CubeAnimState {
  /// the cube is ping ponging (oscillating) will brushing
  brushing,

  /// then it settles up to it's proper size after load or brush is complete
  loading,

  /// In this mode the cube may be settling to it's
  /// proper size after being created with a brush,
  /// or it may just be done,
  /// stationary at full size.
  growingOrDone
}

/// Manages the starting and stopping of cube animation
/// during loading and brushing.
mixin Animator {
  final animCubeInfos = <CubeInfo>[];

  CubeAnimState cubeAnimState = CubeAnimState.growingOrDone;

  /// defined in [Persister]
  Painting get painting;

  /// move all the (static) cubeInfos to animCubeInfos
  @protected
  void startAnimatingLoadedCubes() {
    final List<CubeInfo> cubeInfos = painting.cubeInfos;

    animCubeInfos.clear();
    animCubeInfos.addAll(cubeInfos.toList());

    cubeAnimState = CubeAnimState.loading;
  }

  void startBrushing() {
    finishAnim();

    cubeAnimState = CubeAnimState.brushing;
  }

  /// Stop animating the cubes by removing them from animCubeInfos
  void finishAnim() {
    switch (cubeAnimState) {
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
