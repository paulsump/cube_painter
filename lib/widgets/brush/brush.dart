import 'package:cube_painter/mode.dart';
import 'package:cube_painter/model/crop.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/widgets/brush/brush_maths.dart';
import 'package:cube_painter/widgets/brush/positions.dart';
import 'package:cube_painter/widgets/cubes/anim_cube.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = [out, GridPoint];

class Brush extends StatefulWidget {
  final _cubes = <AnimCube>[];

  final void Function(List<AnimCube> orphans) adoptCubes;

  Brush({
    Key? key,
    required this.adoptCubes,
  }) : super(key: key);

  void _handOver() {
    final orphans = _cubes.toList();

    _cubes.clear();
    adoptCubes(orphans);
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
        switch (getMode(context)) {
          case Mode.zoomPan:
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
      onTapUp: (details) {
        if (getMode(context) == Mode.zoomPan) {
          return;
        }
        _replaceCube(details.localPosition, context);
        widget._handOver();
      },
    );
  }

  void _replaceCube(Offset offset, BuildContext context) {
    final GridPoint position =
    brushMaths.getPosition(screenToUnit(offset, context));

    widget._cubes.clear();
    Crop crop = Crop.c;

    if (getMode(context) == Mode.crop) {
      crop = Provider.of<CropNotifier>(context, listen: false).crop;
    }
    _addCube(widget._cubes, position, crop);
  }

  void _updateExtrude(DragUpdateDetails details, BuildContext context) {
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
    start: 0.0,
    // start: 0.5,
    end: 1.0,
    pingPong: true,
  ));
}
