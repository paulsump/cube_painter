import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/widgets/brush/brush_maths.dart';
import 'package:cube_painter/widgets/brush/positions.dart';
import 'package:cube_painter/widgets/cubes/anim_cube.dart';
import 'package:cube_painter/widgets/transformed.dart';
import 'package:flutter/material.dart';

const noWarn = [out, GridPoint];

class Brush extends StatefulWidget {
  final _cubes = <AnimCube>[];

  final void Function() onStartPan;
  final void Function(List<AnimCube> takenCubes) onEndPan;

  final void Function(List<AnimCube> takenCubes) onTapUp;

  Brush({
    Key? key,
    required this.onStartPan,
    required this.onEndPan,
    required this.onTapUp,
  }) : super(key: key);

  List<AnimCube> _handoverCubes() {
    final listCopy = _cubes.toList();

    _cubes.clear();
    return listCopy;
  }

  @override
  State<Brush> createState() => BrushState();
}

class BrushState extends State<Brush> {
  final brushMaths = BrushMaths();
  var previousPositions = Positions();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          // HACK without this container,
          // onPanStart etc doesn't get called after cubes are added.
          Container(),
          Transformed(
            child: Stack(children: widget._cubes),
          ),
        ],
      ),
      onPanStart: (details) {
        widget.onStartPan();

        brushMaths.startFrom(
          screenToUnit(details.localPosition, context),
        );
      },
      onPanUpdate: (details) {
        final Positions positions = brushMaths.extrudeTo(
          screenToUnit(details.localPosition, context),
        );

        if (previousPositions != positions) {
          // using order provided by extruder
          // only add new cubes, deleting any old ones

          // TODO test that unused ones are destroyed
          var copy = widget._cubes.toList();
          widget._cubes.clear();

          for (GridPoint position in positions.list) {
            AnimCube? cube = _findAt(position, copy);

            if (cube != null) {
              widget._cubes.add(cube);
            } else {
              _addCube(widget._cubes, position, Crop.c);
            }
          }
          setState(() {});
          previousPositions = positions;
        }
      },
      onPanEnd: (details) {
        widget.onEndPan(widget._handoverCubes());
      },
      onTapUp: (details) {
        final GridPoint position = brushMaths.getPosition(
          screenToUnit(details.localPosition, context),
        );

        // TODO When this is a brush mode ,
        //  only add if/when user is happy with position
        // so need to wire frame like the pan
        _addCube(widget._cubes, position, Crop.dl);
        widget.onTapUp(widget._handoverCubes());
      },
    );
  }
}

AnimCube? _findAt(GridPoint position, List<AnimCube> list) {
  for (final cube in list) {
    if (position == cube.info.center) {
      return cube;
    }
  }
  return null;
}

void _addCube(List<AnimCube> cubes, GridPoint center, Crop crop) {

  cubes.add(AnimCube(
    key: UniqueKey(),
    info: CubeInfo(center: center, crop: crop),
    start: 0.5,
    end: 1.0,
    pingPong: true,
  ));
}
