import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// Manages the starting and stopping of cube animation
/// during loading and brushing.
mixin Animator {
  final animCubeInfos = <CubeInfo>[];

  bool isAnimatingLoadedCubes = true;

  bool isBrushing = false;

  /// defined in [Persister]
  Sketch get sketch;

  bool isPingPong = false;

  /// move all the (static) cubeInfos to animCubeInfos
  @protected
  void startAnimatingLoadedCubes() {
    final List<CubeInfo> cubeInfos = sketch.cubeInfos;

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
  }

  void finishAnim() {
    if (!isBrushing) {
      if (!isAnimatingLoadedCubes) {
        sketch.cubeInfos.addAll(animCubeInfos);
      }

      animCubeInfos.clear();
    }
  }

  void setIsPingPong(bool value) => isPingPong = value;
}
