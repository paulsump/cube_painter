import 'package:cube_painter/transform/zoom_pan.dart';
import 'package:flutter/material.dart';

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
  Offset _offset = Offset.zero;

  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double get _scale => getZoomScale(context);

  set _scale(double value) => setZoomScale(context, value);

  double _initialScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        _initialFocalPoint = details.focalPoint;
        _initialScale = _scale;
      },
      onScaleUpdate: (details) {
        _sessionOffset = details.focalPoint - _initialFocalPoint;
        _scale = _initialScale * details.scale;
        widget.setState(() {});
      },
      onScaleEnd: (details) {
        _offset += _sessionOffset;
        _sessionOffset = Offset.zero;
        widget.setState(() {});
      },
      child: Stack(
        children: [
          // HACK without this container,
          // onScaleUpdate etc doesn't get called. 'opaque' is also required.
          Container(),
          if (false)
            Transform.translate(
              offset: _offset + _sessionOffset,
              child: Transform.scale(
                scale: _scale,
                child: const FlutterLogo(),
              ),
            ),
        ],
      ),
    );
  }
}
