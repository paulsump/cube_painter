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

class PanZoomer extends StatelessWidget {
  final _initial = InitialValues();

  PanZoomer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        _initial.focalPoint = details.focalPoint;

        _initial.scale = getZoomScale(context);
        _initial.offset = getPanOffset(context);
      },
      onScaleUpdate: (details) {
        final scale = _initial.scale * details.scale;

        /// TODO Responsive to screen size- magic numbers
        if (scale < 15 || 300 < scale) {
          return;
        }

        if (scale != getZoomScale(context)) {
          setZoomScale(context, scale);
        }

        Offset offset =
            details.focalPoint - _initial.focalPoint + _initial.offset;

        offset *= details.scale;

        // Pan limits - Don’t allow pan past place where can’t zoom limit to.
        /// TODO Responsive to screen size- magic numbers
        offset = Offset(offset.dx.clamp(-100, 130), offset.dy.clamp(-250, 280));

        //TODO See if this makes a diff when the widgets listen
        if (offset != getPanOffset(context)) {
          setPanOffset(context, offset);
        }
      },
      // Without this container, gestures stop working
      // i.e. onScaleUpdate etc doesn't get called. 'opaque' is also required.
      child: Container(),
    );
  }
}
