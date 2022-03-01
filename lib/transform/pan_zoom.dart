import 'package:cube_painter/brush/gesture_handler.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

double getZoomScale(BuildContext context, {bool listen = false}) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: listen);
  return zoom.scale;
}

void setZoomScale(BuildContext context, double scale) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: false);
  zoom.scale = scale;
}

Offset getPanOffset(BuildContext context, {bool listen = false}) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: listen);
  // if (listen) out(zoom.offset);
  return zoom.offset;
}

void setPanOffset(BuildContext context, Offset offset) {
  final zoom = Provider.of<PanZoomNotifier>(context, listen: false);
  zoom.offset = offset;
}

class PanZoomNotifier extends ChangeNotifier {
  /// equates to the length of the side of each triangle in pixels
  /// TODO Responsive to screen size- magic numbers
  double _scale = 30;

  Offset _offset = Offset.zero;

  double get scale => _scale;

  set scale(double value) {
    _scale = value;
    notifyListeners();
  }

  Offset get offset => _offset;

  set offset(Offset value) {
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
    if (scale < 15 || 300 < scale) {
      return;
    }

    if (scale != getZoomScale(context)) {
      setZoomScale(context, scale);
    }

    Offset offset = point - _initial.focalPoint + _initial.offset;

    offset *= scale_;

    // Pan limits - Don’t allow pan past place where can’t zoom limit to.
    /// TODO Responsive to screen size- magic numbers
    out(offset);
    offset = Offset(offset.dx.clamp(-500, 500), offset.dy.clamp(-340, 500));

    //TODO See if this makes a diff when the widgets listen
    if (offset != getPanOffset(context)) {
      setPanOffset(context, offset);
    }
  }

  @override
  void end(BuildContext context) {
  }

  @override
  void tapDown(Offset point, BuildContext context) {
  }

  @override
  void tapUp(Offset point, BuildContext context) {
  }
}
