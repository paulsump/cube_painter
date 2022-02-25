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
  late Offset _initialFocalPoint;
  late Offset _initialOffset;

  late double _initialScale;

  void init() {}
}

class PanZoomer extends StatelessWidget {
  late Offset _initialFocalPoint;
  late Offset _initialOffset;

  // final InitialValues _initialValues;
  PanZoomer({Key? key}) : super(key: key);

  late double _initialScale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        _initialFocalPoint = details.focalPoint;

        _initialScale = getZoomScale(context);
        _initialOffset = getPanOffset(context);
      },
      onScaleUpdate: (details) {
        final scale = _initialScale * details.scale;

        if (scale < 15 || 300 < scale) {
          return;
        }

        if (scale != getZoomScale(context)) {
          setZoomScale(context, scale);
        }

        Offset offset =
            details.focalPoint - _initialFocalPoint + _initialOffset;

        offset *= details.scale;

        //TODO See if this makes a diff when the tiles widget listens
        if (offset != getPanOffset(context)) {
//TODO PAN LIMITS
          setPanOffset(context, offset);
        }
      },
      // Without this container, gestures stop working
      // i.e. onScaleUpdate etc doesn't get called. 'opaque' is also required.
      child: Container(),
    );
  }
}
