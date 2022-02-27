import 'package:cube_painter/data/sketch.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

typedef StringList = List<String>;

class Undoer {
  final BuildContext context;
  final void Function(VoidCallback fn) setState;

  final StringList _undos = [];
  final StringList _redos = [];

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

  void _popFromPushTo(StringList popFrom, StringList pushTo) {
    _saveTo(pushTo);

    final sketchBank = getSketchBank(context);
    sketchBank.setJson(popFrom.removeLast());
  }

  void _saveTo(StringList list) {
    list.add(getSketchBank(context).json);
  }
}
