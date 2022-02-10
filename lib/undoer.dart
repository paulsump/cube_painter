import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:flutter/material.dart';

typedef DoList = List<List<CubeInfo>>;

class Undoer {
  final List<SimpleCube> simpleCubes;

  final DoList _undos = [];
  final DoList _redos = [];

  Undoer(this.simpleCubes);

  bool get hasUndos => _undos.isNotEmpty;

  bool get hasRedos => _redos.isNotEmpty;

  void save() {
    _saveTo(_undos);

    _redos.clear();
  }

  void undo(setState) {
    _popFromPushTo(_undos, _redos);
    setState(() {});
  }

  void redo(setState) {
    _popFromPushTo(_redos, _undos);
    setState(() {});
  }

  void _popFromPushTo(DoList popFrom, DoList pushTo) {
    _saveTo(pushTo);

    simpleCubes.clear();
    final List<CubeInfo> cubeInfos = popFrom.removeLast();

    for (final CubeInfo cubeInfo in cubeInfos) {
      simpleCubes.add(SimpleCube(key: UniqueKey(), info: cubeInfo));
    }
  }

  void _saveTo(DoList list) => list.add(
        List.generate(simpleCubes.length, (index) => simpleCubes[index].info),
      );
}
