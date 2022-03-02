import 'package:cube_painter/gestures/gesture_handler.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

void initZoomScaleFirstTimeOnly(BuildContext context, double scale) {
  final panZoomNotifier = _getPanZoomNotifier(context, listen: false);

  if (panZoomNotifier._scale == 0) {
    panZoomNotifier._scale = scale;
  }
}

double getZoomScale(BuildContext context, {bool listen = false}) =>
    _getPanZoomNotifier(context, listen: listen).scale;

void setZoomScale(BuildContext context, double scale) =>
    _getPanZoomNotifier(context, listen: false).setScale(scale);

Offset getPanOffset(BuildContext context, {bool listen = false}) =>
    _getPanZoomNotifier(context, listen: listen).offset;

void setPanOffset(BuildContext context, Offset offset) =>
    _getPanZoomNotifier(context, listen: false).setOffset(offset);

PanZoomNotifier _getPanZoomNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<PanZoomNotifier>(context, listen: listen);

/// For zooming and panning,
/// this stores the global scale and pan offset.
class PanZoomNotifier extends ChangeNotifier {
  /// equates to the length of the side of each triangle in pixels
  /// set by initZoomScale() to around 30
  double _scale = 0;

  Offset _offset = Offset.zero;

  double get scale => _scale;

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

class InitialValues {
  late Offset focalPoint;
  late Offset offset;

  late double scale;
}

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

    /// TODO Responsive to screen size- magic numbers
    if (scale < 15 || 150 < scale) {
      return;
    }

    if (scale != getZoomScale(context)) {
      setZoomScale(context, scale);
    }

    Offset offset = point - _initial.focalPoint + _initial.offset;

    offset *= scale_;

    // Pan limits - Don’t allow pan past place where can’t zoom limit to.
    /// TODO Responsive to screen size- magic numbers
    offset = Offset(offset.dx.clamp(-500, 500), offset.dy.clamp(-340, 500));

    //TODO See if this makes a diff when the widgets listen
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
