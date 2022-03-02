import 'dart:async';
import 'dart:io';

import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/persister.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

SketchBank getSketchBank(BuildContext context, {bool listen = false}) =>
    Provider.of<SketchBank>(context, listen: listen);

/// access to the main store of the entire model
/// For loading and saving all the cube positions and their info
/// loaded from a json file.
/// Also manages the starting and stopping of cube animation
/// during loading and brushing.
/// init() is the main starting point for the app.
/// TODO MOVe anim stuff into Animator
class SketchBank extends ChangeNotifier with Persister {
  void startBrushing() {
    setIsPingPong(true);
    finishAnim();

    isBrushing = true;
    notifyListeners();
  }

  /// Add all the animCubeInfos to the staticCubeInfos,
  /// thus, if there were any cubes still animating,
  /// then they would appear to stop immediately.
  //TODO FIx this copied comment
  /// once the brush has finished, it
  /// yields ownership of it's cubes to this parent widget.
  /// which then creates a similar list
  /// If we are in add gestureMode
  /// the cubes will end up going
  /// in the sketch once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubeInfos array once the
  /// anim is done.
  void finishAnim() {
    if (!isBrushing) {
      if (!isAnimatingLoadedCubes) {
        sketch.cubeInfos.addAll(animCubeInfos);
      }

      animCubeInfos.clear();
      notifyListeners();
    }
  }

  void setIsPingPong(bool value) {
    isPingPong = value;
    notifyListeners();
  }

  void updateAfterLoad(BuildContext context) {
    // TODO if fail, alert user, perhaps skip
    // TODO iff finally:
    if (sketches.isNotEmpty) {
      getUndoer(context).clear();

      startAnimatingLoadedCubes();
      notifyListeners();
    }
  }

  /// Creates a sketch from a json string
  /// called from [UndoNotifier]
  void setJson(String json) {
    setSketch(Sketch.fromString(json));

    notifyListeners();
  }

  Future<void> deleteCurrentFile(BuildContext context) async {
    sketches.remove(currentFilePath);

    final File file = File(currentFilePath);

    // we might never have saved a new filename, so check existence
    if (await file.exists()) {
      file.delete();
    }

    if (sketches.isEmpty) {
      await newFile(context);
    } else {
      loadFile(filePath: sketches.keys.first, context: context);
    }

    notifyListeners();
  }
}
