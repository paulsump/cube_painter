import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

typedef StringList = List<String>;

UndoNotifier getUndoer(context, {bool listen = false}) =>
    Provider.of<UndoNotifier>(context, listen: listen);

void saveForUndo(BuildContext context) => getUndoer(context).save(context);

/// Provides access to the undo / redo mechanism.
/// notifies for the [_UndoButton] states in [PageButtons]
/// [SketchBank]  notifies the page in [setJson]
class UndoNotifier extends ChangeNotifier {
  final StringList _undos = [];
  final StringList _redos = [];

  bool get canUndo => _undos.isNotEmpty;

  bool get canRedo => _redos.isNotEmpty;

  void clear() {
    _undos.clear();
    _redos.clear();
    notifyListeners();
  }

  void save(BuildContext context) {
    _undos.add(getSketchBank(context).json);
    _redos.clear();

    out('save');
    out(_undos);
    notifyListeners();
  }

  void undo(BuildContext context) {
    out('undo');
    _popFromPushTo(_undos, _redos, context);
  }

  void redo(BuildContext context) {
    out('redo');
    _popFromPushTo(_redos, _undos, context);
  }

  void _popFromPushTo(
    StringList popFrom,
    StringList pushTo,
    BuildContext context,
  ) {
    pushTo.add(getSketchBank(context).json);

    final sketchBank = getSketchBank(context);
    sketchBank.setJson(popFrom.removeLast());

    out(_undos);
    out(_redos);

    notifyListeners();
  }
}
