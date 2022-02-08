import 'package:cube_painter/model/cube_group.dart';
import 'package:flutter/material.dart';

class CubeStore extends ChangeNotifier {
  final _cubeGroups = <CubeGroup>[CubeGroup([])];

  bool isFirstTime = true;

  CubeGroup getCurrentCubeGroup() {
    return _cubeGroups[0];
  }

  void add(CubeGroup cubeGroup) {
    if (isFirstTime) {
      _cubeGroups.clear();
    }
    _cubeGroups.add(cubeGroup);
  }

  void replace(CubeGroup cubeGroup) {
    _cubeGroups.clear();
    _cubeGroups.add(cubeGroup);
  }
}
