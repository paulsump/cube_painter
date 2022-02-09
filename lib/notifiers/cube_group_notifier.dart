import 'package:cube_painter/model/cube_group.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

// TODO only load and keep one CubeGroup
class CubeGroupNotifier extends ChangeNotifier {
  final _cubeGroups = <CubeGroup>[const CubeGroup([])];

  bool isFirstTime = true;
  int _currentIndex = 0;

  void increment(int increment) {
    _currentIndex += increment;
    _currentIndex %= _cubeGroups.length;
  }

  CubeGroup getCurrentCubeGroup() {
    return _cubeGroups[_currentIndex];
  }

  void add(CubeGroup cubeGroup) {
    if (isFirstTime) {
      _cubeGroups.clear();
    }
    _cubeGroups.add(cubeGroup);
  }
//
// void replace(CubeGroup cubeGroup) {
//   _cubeGroups.clear();
//   _cubeGroups.add(cubeGroup);
// }
}
