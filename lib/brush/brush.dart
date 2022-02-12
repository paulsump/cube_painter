import 'package:cube_painter/brush/brush_maths.dart';
import 'package:cube_painter/brush/positions.dart';
import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Position];

class Brush extends StatefulWidget {
  final _cubes = <AnimCube>[];

  final void Function(List<AnimCube> orphans) adoptCubes;

  Brush({
    Key? key,
    required this.adoptCubes,
  }) : super(key: key);

  void _handOver() {
    if (_cubes.isNotEmpty) {
      final orphans = _cubes.toList();

      _cubes.clear();
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
          UnitToScreen(
            child: Stack(children: widget._cubes),
          ),
        ],
      ),
      onPanStart: (details) {
        brushMaths.startFrom(
          screenToUnit(details.localPosition, context),
        );
      },
      onPanUpdate: (details) {
        // TODO if(details.scale!=1) {zoomer.scaleUpdate)else{
        switch (getMode(context)) {
          case Mode.panZoom:
            break;
          case Mode.add:
            _updateExtrude(details, context);
            break;
          case Mode.erase:
            _replaceCube(details.localPosition, context);
            setState(() {});
            break;
          case Mode.crop:
            _replaceCube(details.localPosition, context);
            setState(() {});
            break;
        }
      },
      onPanEnd: (details) {
        widget._handOver();
      },
      onTapDown: (details) {
        if (getMode(context) == Mode.panZoom) {
          return;
        }
        _replaceCube(details.localPosition, context);
        setState(() {});
      },
      onTapUp: (details) {
        widget._handOver();
      },
    );
  }

  void _replaceCube(Offset offset, BuildContext context) {
    final Position position =
        brushMaths.getPosition(screenToUnit(offset, context));

    widget._cubes.clear();
    Crop crop = Crop.c;

    if (getMode(context) == Mode.crop) {
      crop = Provider.of<CropNotifier>(context, listen: false).crop;
    }

    _addCube(position, crop);
  }

  void _updateExtrude(details, BuildContext context) {
    final Positions positions = brushMaths.extrudeTo(
      screenToUnit(details.localPosition, context),
    );

    if (previousPositions != positions) {
      // using order provided by extruder
      // only add new cubes, deleting any old ones

      var copy = widget._cubes.toList();
      widget._cubes.clear();

      for (Position position in positions.list) {
        AnimCube? cube = _findAt(position, copy);

        if (cube != null) {
          widget._cubes.add(cube);
        } else {
          _addCube(position, Crop.c);
        }
      }
      setState(() {});
      previousPositions = positions;
    }
  }

  void _addCube(Position center, Crop crop) {
    widget._cubes.add(AnimCube(
      key: UniqueKey(),
      info: CubeInfo(center: center, crop: crop),
      start: 0.0,
      end: getMode(context) == Mode.erase ? 3.0 : 1.0,
      pingPong: true,
      wire: getMode(context) == Mode.erase,
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
