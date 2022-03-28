// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Access the provider
UndoNotifier getUndoer(context, {bool listen = false}) =>
    Provider.of<UndoNotifier>(context, listen: listen);

/// Use the provider
void saveForUndo(BuildContext context) => getUndoer(context).save(context);

/// Provides access to the undo / redo mechanism.
///
/// notifies for the [_UndoButton] states in [PageButtons]
/// [PaintingBank]  notifies the page in [setJson]
class UndoNotifier extends ChangeNotifier {
  final _undos = <String>[];
  final _redos = <String>[];

  bool get canUndo => _undos.isNotEmpty;

  bool get canRedo => _redos.isNotEmpty;

  void clear() {
    _undos.clear();
    _redos.clear();
    notifyListeners();
  }

  void save(BuildContext context) {
    _undos.add(getPaintingBank(context).json);
    _redos.clear();

    notifyListeners();
  }

  void undo(BuildContext context) {
    // Just in case the animation is still going, clear the AnimCubeInfos
    getPaintingBank(context).finishAnim();

    _popFromPushTo(_undos, _redos, context);
  }

  void redo(BuildContext context) => _popFromPushTo(_redos, _undos, context);

  void _popFromPushTo(List<String> popFrom,
      List<String> pushTo,
      BuildContext context) {
    final paintingBank = getPaintingBank(context);

    pushTo.add(paintingBank.json);
    paintingBank.setJson(popFrom.removeLast());

    notifyListeners();
  }
}
