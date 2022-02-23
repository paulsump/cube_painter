import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

typedef JsonList = List<String>;

class Undoer {
  final BuildContext context;
  final void Function(VoidCallback fn) setState;

  final JsonList _undos = [];
  final JsonList _redos = [];

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

  void _popFromPushTo(JsonList popFrom, JsonList pushTo) {
    _saveTo(pushTo);

    final notifier = getCubeGroupNotifier(context);
    notifier.setJson(popFrom.removeLast());
  }

  void _saveTo(JsonList list) {
    final notifier = getCubeGroupNotifier(context);
    list.add(notifier.json);
  }
}
