import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

typedef DoList = List<List<CubeInfo>>;

class Undoer {
  final List<StaticCube> staticCubes;
  final void Function(VoidCallback fn) setState;

  final DoList _undos = [];
  final DoList _redos = [];

  Undoer(this.staticCubes, {required this.setState});

  bool get canUndo => _undos.isNotEmpty;

  bool get canRedo => _redos.isNotEmpty;

  void save() {
    _saveTo(_undos);
    _redos.clear();
  }

  void undo() {
    _popFromPushTo(_undos, _redos);
    setState(() {});
  }

  void redo() {
    _popFromPushTo(_redos, _undos);
    setState(() {});
  }

  void _popFromPushTo(DoList popFrom, DoList pushTo) {
    _saveTo(pushTo);

    staticCubes.clear();
    _addStaticCubes(popFrom.removeLast());
  }

  void _addStaticCubes(List<CubeInfo> cubeInfos) {
    for (final CubeInfo cubeInfo in cubeInfos) {
      staticCubes.add(StaticCube(key: UniqueKey(), info: cubeInfo));
    }
  }

  void _saveTo(DoList list) => list.add(
      List.generate(staticCubes.length, (index) => staticCubes[index].info));
}
