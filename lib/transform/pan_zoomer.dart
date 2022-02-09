import 'package:flutter/material.dart';

class PanZoomer extends StatefulWidget {
  @override
  _PanZoomerState createState() => _PanZoomerState();
}

class _PanZoomerState extends State<PanZoomer> {
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double _initialScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _initialFocalPoint = details.focalPoint;
        _initialScale = _scale;
      },
      onScaleUpdate: (details) {
        setState(() {
          _sessionOffset = details.focalPoint - _initialFocalPoint;
          _scale = _initialScale * details.scale;
        });
      },
      onScaleEnd: (details) {
        setState(() {
          _offset += _sessionOffset;
          _sessionOffset = Offset.zero;
        });
      },
      child: Transform.translate(
        offset: _offset + _sessionOffset,
        child: Transform.scale(
          scale: _scale,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
