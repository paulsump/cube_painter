import 'package:cube_painter/shared/brush_maths.dart';
import 'package:cube_painter/shared/enums.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:flutter/material.dart';

class Brush extends StatefulWidget {
  final _cubes = <Cube>[];

  final void Function() onStartPan;
  final void Function(List<Cube> takenBoxes) onEndPan;

  final void Function(List<Cube> takenBoxes) onTapUp;
  final Crop crop;

  final bool erase;

  Brush({
    Key? key,
    required this.onStartPan,
    required this.onEndPan,
    required this.onTapUp,
    required this.crop,
    required this.erase
  }) : super(key: key);

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
      child: Stack(children: widget._cubes),
      onPanStart: (details) {
        widget.onStartPan();
        // brushMaths.startFrom(zoomOffset(details.localPosition, context));
      },
      onPanUpdate: (details) {
        // brushMaths.extrudeTo(
        //   widget._cubes,
        //   zoomOffset(details.localPosition, context)
        // );
        setState(() {});
      },
      onPanEnd: (details) {
        widget.onEndPan(widget._takeBoxes());
      },

      onTapUp: (details) {
        // brushMaths.setCropBox(
        //   widget._cubes,
        //   zoomOffset(details.localPosition, context),
        //   widget.crop,
        // );

        setState(() {});
        widget.onTapUp(widget._takeBoxes());
      },
    );
  }
}
