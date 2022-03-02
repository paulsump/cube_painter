import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/cube_info.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// access to the main store of the entire model
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
/// Also manages the starting and stopping of cube animation
/// during loading and brushing.
/// init() is the main starting point for the app.
/// TODO MOVe anim stuff into Animator
/// todo move load stuff into Persister
mixin Animator {
  final animCubeInfos = <CubeInfo>[];

  bool isAnimatingLoadedCubes = true;

  bool isBrushing = false;

  void setIsPingPong(bool value);

  void finishAnim();

  Sketch get sketch;

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

  bool isPingPong = false;
}
