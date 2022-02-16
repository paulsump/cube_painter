import 'package:cube_painter/brush/brush_maths.dart';
import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

class Brush extends StatefulWidget {
  final _animCubes = <AnimCube>[];

  final void Function(List<AnimCube> orphans) adoptCubes;

  Brush({Key? key, required this.adoptCubes}) : super(key: key);

  void _handOver() {
    if (_animCubes.isNotEmpty) {
      final orphans = _animCubes.toList();

      _animCubes.clear();
      adoptCubes(orphans);
    }
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
          UnitToScreen(child: Stack(children: widget._animCubes)),
        ],
      ),
      onPanStart: (details) =>
          brushMaths.startFrom(screenToUnit(details.localPosition, context)),
      onPanUpdate: (details) {
        if (GestureMode.add == getGestureMode(context)) {
          _updateExtrude(details, context);
        } else {
          _replaceCube(details.localPosition, context);
          setState(() {});
        }
      },
      onPanEnd: (details) => widget._handOver(),
      onTapDown: (details) {
        _replaceCube(details.localPosition, context);
        setState(() {});
      },
      onTapUp: (details) => widget._handOver(),
    );
  }

  void _replaceCube(Offset point, BuildContext context) {
    widget._animCubes.clear();
    Crop crop = Crop.c;

    if (getGestureMode(context) == GestureMode.crop) {
      crop = Provider.of<CropNotifier>(context, listen: false).crop;
    }

    _addCube(brushMaths.getPosition(screenToUnit(point, context)), crop);
  }

  void _updateExtrude(details, BuildContext context) {
    final Positions positions = brushMaths.extrudeTo(
      screenToUnit(details.localPosition, context),
    );

    if (previousPositions != positions) {
      // using order provided by extruder
      // only add new cubes, deleting any old ones

      var copy = widget._animCubes.toList();
      widget._animCubes.clear();

      for (Position position in positions.list) {
        AnimCube? cube = _findAt(position, copy);

        if (cube != null) {
          widget._animCubes.add(cube);
        } else {
          _addCube(position, Crop.c);
        }
      }
      setState(() {});
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Crop crop) {
    widget._animCubes.add(AnimCube(
      key: UniqueKey(),
      info: CubeInfo(center: center, crop: crop),
      start: 0.0,
      end: getGestureMode(context) == GestureMode.add ? 1.0 : 3.0,
      pingPong: true,
    ));
  }
}

AnimCube? _findAt(Position position, List<AnimCube> list) {
  for (final cube in list) {
    if (position == cube.info.center) {
      return cube;
    }
  }
  return null;
}
