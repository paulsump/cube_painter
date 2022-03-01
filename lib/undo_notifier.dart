import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

typedef StringList = List<String>;

UndoNotifier getUndoer(context) => Provider.of<UndoNotifier>(context);

void saveForUndo(BuildContext context) => getUndoer(context).save(context);

class UndoNotifier extends ChangeNotifier {
  final StringList _undos = [];
  final StringList _redos = [];

  bool get canUndo => _undos.isNotEmpty;

  bool get canRedo => _redos.isNotEmpty;

  void clear() {
    _undos.clear();
    _redos.clear();
  }

  void save(BuildContext context) {
    _saveTo(_undos, context);
    _redos.clear();
  }

  void undo(BuildContext context) {
    _popFromPushTo(_undos, _redos, context);
    notifyListeners();
  }

  void redo(BuildContext context) {
    _popFromPushTo(_redos, _undos, context);
    notifyListeners();
  }

  void _popFromPushTo(
      StringList popFrom, StringList pushTo, BuildContext context) {
    _saveTo(pushTo, context);

    final sketchBank = getSketchBank(context);
    sketchBank.setJson(popFrom.removeLast());
  }

  void _saveTo(StringList list, BuildContext context) {
    list.add(getSketchBank(context).json);
  }
}
