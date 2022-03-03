import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// Manages the starting and stopping of cube animation
/// during loading and brushing.
mixin Animator {
  final animCubeInfos = <CubeInfo>[];

  bool isAnimatingLoadedCubes = false;

  bool isBrushing = true;

  /// defined in [Persister]
  Painting get painting;

  bool isPingPong = false;

  /// move all the (static) cubeInfos to animCubeInfos
  @protected
  void startAnimatingLoadedCubes() {
    final List<CubeInfo> cubeInfos = painting.cubeInfos;

    animCubeInfos.clear();
    animCubeInfos.addAll(cubeInfos.toList());

    isAnimatingLoadedCubes = true;

    // for correctness and just in case (i saw it ping pong forever one)
    setIsPingPong(false);
  }

  void startBrushing() {
    setIsPingPong(true);

    finishAnim();
    isBrushing = true;

    isAnimatingLoadedCubes = false;
  }

  void finishAnim() {
    if (!isBrushing) {
      if (!isAnimatingLoadedCubes) {
        painting.cubeInfos.addAll(animCubeInfos);
      }

      animCubeInfos.clear();
    }
  }

  void setIsPingPong(bool value) => isPingPong = value;
}
