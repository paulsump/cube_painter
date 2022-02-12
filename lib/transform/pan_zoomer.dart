import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class PanZoomer extends StatefulWidget {
  final void Function(void Function()) setState;

  const PanZoomer({
    Key? key,
    required this.setState,
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
        widget.setState(() {});
      },
      onScaleEnd: (details) {
        _sessionOffset = Offset.zero;
        widget.setState(() {});
      },
      // Without this container, gestures stop working
      // i.e. onScaleUpdate etc doesn't get called. 'opaque' is also required.
      child: Container(),
    );
  }
}
