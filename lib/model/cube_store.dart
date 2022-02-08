import 'package:cube_painter/model/cube_group.dart';
import 'package:flutter/material.dart';

class CubeStore extends ChangeNotifier {
  final _cubeGroups = <CubeGroup>[CubeGroup([])];

  CubeGroup getCurrentCubeGroup() {
    return _cubeGroups[0];
  }
}
