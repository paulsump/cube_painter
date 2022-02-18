import 'dart:convert';

import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

typedef DoList = List<String>;

class Undoer {
  final BuildContext context;
  final void Function(VoidCallback fn) setState;

  final DoList _undos = [];
  final DoList _redos = [];

  Undoer(this.context, {required this.setState});

  bool get canUndo => _undos.isNotEmpty;

  bool get canRedo => _redos.isNotEmpty;

  void clear() {
    _undos.clear();
    _redos.clear();
  }

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

    final notifier = getCubeGroupNotifier(context);
    final json = popFrom.removeLast();

    Map<String, dynamic> map = jsonDecode(json);
    notifier.cubeGroup = CubeGroup.fromJson(map);
  }

  void _saveTo(DoList list) {
    final notifier = getCubeGroupNotifier(context);
    list.add(notifier.json);
  }
}
