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

  set _scale(double value) => setZoomScale(context, value);

  Offset get _offset => getPanOffset(context);

  set _offset(Offset value) => setPanOffset(context, value);

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
        _offset = _sessionOffset + _initialOffset;

        widget.setState(() {});
      },
      onScaleEnd: (details) {
        _offset = _sessionOffset + _initialOffset;
        _sessionOffset = Offset.zero;
        widget.setState(() {});
      },
      child: Stack(
        children: [
          // HACK without this container,
          // onScaleUpdate etc doesn't get called. 'opaque' is also required.
          Container(),
          // Transform.translate(
          //   offset: _offset + _sessionOffset,
          //   child: Transform.scale(
          //     scale: _scale,
          //     child: const FlutterLogo(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
