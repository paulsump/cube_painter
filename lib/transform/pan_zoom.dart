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

class PanZoomer extends StatefulWidget {
  final VoidCallback onPanZoomUpdate;
  final VoidCallback onPanZoomEnd;

  const PanZoomer({
    Key? key,
    required this.onPanZoomUpdate,
    required this.onPanZoomEnd,
  }) : super(key: key);

  @override
  _PanZoomerState createState() => _PanZoomerState();
}

class _PanZoomerState extends State<PanZoomer> {
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;
  Offset _initialOffset = Offset.zero;

  double get _scale => getZoomScale(context);

  Offset get _offset => getPanOffset(context);

  set _offset(Offset value) => setPanOffset(context, value);

  set _scale(double value) => setZoomScale(context, value);

  double _initialScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        _initialFocalPoint = details.focalPoint;

        _initialScale = _scale;
        _initialOffset = _offset;
      },
      onScaleUpdate: (details) {
        _scale = _initialScale * details.scale;

        _sessionOffset = details.focalPoint - _initialFocalPoint;
        final newOffset = _sessionOffset + _initialOffset;

        _offset = newOffset * details.scale;
        widget.onPanZoomUpdate();
      },
      onScaleEnd: (details) {
        _sessionOffset = Offset.zero;
        widget.onPanZoomEnd();
      },
      // Without this container, gestures stop working
      // i.e. onScaleUpdate etc doesn't get called. 'opaque' is also required.
      child: Container(),
    );
  }
}
