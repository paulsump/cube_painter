import 'package:cube_painter/shared/brush_maths.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:flutter/material.dart';

class Brush extends StatefulWidget {
  final _cubes = <Cube>[];

  final void Function() onStartPan;
  final void Function(List<Cube> takenBoxes) onEndPan;

  final void Function(List<Cube> takenBoxes) onTapUp;
  final Crop crop;

  final bool erase;

  Brush(
      {Key? key,
      required this.onStartPan,
      required this.onEndPan,
      required this.onTapUp,
      required this.crop,
      required this.erase})
      : super(key: key);

  List<Cube> _takeBoxes() {
    final listCopy = _cubes.toList();

    _cubes.clear();
    return listCopy;
  }

  @override
  State<Brush> createState() => BrushState();
}

class BrushState extends State<Brush> {
  final brushMaths = BrushMaths();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Transform.translate(
        offset: Offset(Screen.width / 2, Screen.height / 2),
        // offset: Screen.origin,
        child: Transform.scale(
            scale: getZoomScale(context),
            child: Stack(children: widget._cubes)),
      ),
      onPanStart: (details) {
        widget.onStartPan();
        brushMaths.startFrom(details.localPosition / getZoomScale(context));
      },
      onPanUpdate: (details) {
        brushMaths.extrudeTo(
          widget._cubes,
          details.localPosition / getZoomScale(context),
        );
        setState(() {});
      },
      onPanEnd: (details) {
        widget.onEndPan(widget._takeBoxes());
      },
      onTapUp: (details) {
        brushMaths.setCroppedCube(
          widget._cubes,
          details.localPosition / getZoomScale(context),
          widget.crop,
        );

        setState(() {});
        widget.onTapUp(widget._takeBoxes());
      },
    );
  }
}
