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
    if (!isBrushing) {
      if (!isAnimatingLoadedCubes) {
        painting.cubeInfos.addAll(animCubeInfos);
      }

      animCubeInfos.clear();
    }
  }

  void setIsPingPong(bool value) => isPingPong = value;
}
