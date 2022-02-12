import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

typedef DoList = List<List<CubeInfo>>;

class Undoer {
  final List<SimpleCube> simpleCubes;

  final DoList _undos = [];
  final DoList _redos = [];

  Undoer(this.simpleCubes);

  bool get canUndo => _undos.isNotEmpty;

  bool get canRedo => _redos.isNotEmpty;

  void save() {
    _saveTo(_undos);
    _redos.clear();
  }

  void undo() => _popFromPushTo(_undos, _redos);

  void redo() => _popFromPushTo(_redos, _undos);

  void _popFromPushTo(DoList popFrom, DoList pushTo) {
    _saveTo(pushTo);

    simpleCubes.clear();
    _addSimpleCubes(popFrom.removeLast());
  }

  void _addSimpleCubes(List<CubeInfo> cubeInfos) {
    for (final CubeInfo cubeInfo in cubeInfos) {
      simpleCubes.add(SimpleCube(key: UniqueKey(), info: cubeInfo));
    }
  }

  void _saveTo(DoList list) => list.add(
        List.generate(simpleCubes.length, (index) => simpleCubes[index].info),
      );
}
