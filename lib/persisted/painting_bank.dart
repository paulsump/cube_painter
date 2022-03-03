import 'dart:async';

import 'package:cube_painter/gestures/pan_zoom.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/animator.dart';
import 'package:cube_painter/persisted/painting.dart';
import 'package:cube_painter/persisted/persister.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

PaintingBank getPaintingBank(BuildContext context, {bool listen = false}) =>
    Provider.of<PaintingBank>(context, listen: listen);

/// Access to the main store of the entire model
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
/// Also manages the starting and stopping of cube animation
/// during loading and brushing.
/// init() is the main starting point for the app.
class PaintingBank extends ChangeNotifier with Persister, Animator {
  @override
  void startBrushing() {
    super.startBrushing();

    notifyListeners();
  }

  @override
  void finishAnim() {
    super.finishAnim();

    if (cubeState != CubeState.brushing) {
      notifyListeners();
    }
  }

  @override
  void updateAfterLoad(BuildContext context) {
    setPanOffset(context, Offset.zero);

    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    if (paintings.isNotEmpty) {
      getUndoer(context).clear();

      startAnimatingLoadedCubes();
      notifyListeners();
    }
  }

  /// Creates a painting from a json string
  /// called from [UndoNotifier]
  void setJson(String json) {
    setPainting(Painting.fromString(json));

    notifyListeners();
  }

  @override
  Future<void> deleteCurrentFile(BuildContext context) async {
    await super.deleteCurrentFile(context);

    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
