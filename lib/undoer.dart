import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:flutter/material.dart';

typedef DoList = List<List<CubeInfo>>;

class Undoer {
  final List<SimpleCube> simpleCubes;

  final DoList _undos = [];
  final DoList _redos = [];

  Undoer(this.simpleCubes);

  void save() {
    _saveTo(_undos);

    // out(str(_undos));
    _redos.clear();
  }

  void undo(setState) {
    _popFromPushTo(_undos, _redos);
    // out('${str(_undos)}, ${str(_redos)}->${simpleCubes.length}');
    setState(() {});
  }

  void redo(setState) {
    _popFromPushTo(_redos, _undos);
    // out('${str(_undos)}, ${str(_redos)}->${simpleCubes.length}');
    setState(() {});
  }

  // String str(List list) {
  //   final lengths = <int>[];
  //
  //   for (final item in list) {
  //     lengths.add(item.length);
  //   }
  //   return '${list.length}($lengths)';
  // }

  void _popFromPushTo(DoList popFrom, DoList pushTo) {
    _saveTo(pushTo);
    final List<CubeInfo> cubeInfos = popFrom.removeLast();

    // _animCubes.clear();
    simpleCubes.clear();

    for (final CubeInfo cubeInfo in cubeInfos) {
      simpleCubes.add(SimpleCube(key: UniqueKey(), info: cubeInfo));
    }
  }

  void _saveTo(DoList list) => list.add(
        List.generate(simpleCubes.length, (index) => simpleCubes[index].info),
      );
}
