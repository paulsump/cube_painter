// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:cube_painter/gestures/gesture_handler.dart';
import 'package:cube_painter/transform/screen_adjust.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double getZoomScale(BuildContext context, {bool listen = false}) =>
    getPanZoomNotifier(context, listen: listen).scale;

void setZoomScale(BuildContext context, double scale) =>
    getPanZoomNotifier(context, listen: false).setScale(scale);

Offset getPanOffset(BuildContext context, {bool listen = false}) =>
    getPanZoomNotifier(context, listen: listen).offset;

void setPanOffset(BuildContext context, Offset offset) =>
    getPanZoomNotifier(context, listen: false).setOffset(offset);

PanZoomNotifier getPanZoomNotifier(BuildContext context,
    {required bool listen}) =>
    Provider.of<PanZoomNotifier>(context, listen: listen);

/// For zooming and panning, with two fingers.
/// Stores the global scale and pan offset.
class PanZoomNotifier extends ChangeNotifier {
  /// _scale equates to the length of the side of each triangle in pixels
  /// set by initZoomScale() to around 30
  double _scale = 0;

  Offset _offset = Offset.zero;

  double get scale => _scale;

  void initializeScale(double value) {
    assert(scale == 0);
    _scale = value;
  }

  void setScale(double value) {
    _scale = value;
    notifyListeners();
  }

  Offset get offset => _offset;

  void setOffset(Offset value) {
    _offset = value;
    notifyListeners();
  }
}

/// Data only, set at the start of a drag.
class InitialValues {
  late Offset focalPoint;
  late Offset offset;

  late double scale;
}

/// Called from [Gesturer] to scale and offset the page.
class PanZoomer implements GestureHandler {
  final _initial = InitialValues();

  @override
  void start(Offset point, BuildContext context) {
    _initial.focalPoint = point;

    _initial.scale = getZoomScale(context);
    _initial.offset = getPanOffset(context);
  }

  @override
  void update(Offset point, double scale_, BuildContext context) {
    final scale = _initial.scale * scale_;

    final minScale = screenAdjust(0.03247, context);
    final maxScale = 10 * minScale;

    if (minScale < scale &&
        scale < maxScale &&
        scale != getZoomScale(context)) {
      setZoomScale(context, scale);
    }

    Offset offset = point - _initial.focalPoint + _initial.offset;
    offset *= scale_;

    /// Pan limits - Don’t allow pan past place where can’t zoom limit to.
    final xMax = screenAdjust(1.08225, context);

    final xMin = -xMax;
    final yMax = xMax;

    // TODO DO THIS WITH SCREEN HEIGHT INSTEAD
    final yMin = screenAdjust(-0.3, context);
    offset = Offset(offset.dx.clamp(xMin, xMax), offset.dy.clamp(yMin, yMax));

    //TODO See if this 'if' makes any diff when the widgets listen
    if (offset != getPanOffset(context)) {
      setPanOffset(context, offset);
    }
  }

  @override
  void end(BuildContext context) {}

  @override
  void tapDown(Offset point, BuildContext context) {}

  @override
  void tapUp(Offset point, BuildContext context) {}
}
