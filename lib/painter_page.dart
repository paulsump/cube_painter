import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/grid.dart';
import 'package:cube_painter/line.dart';
import 'package:cube_painter/mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/tile.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/undoer.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const noWarn = [out, getScreen, Line, PanZoomer];

class PainterPage extends StatefulWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final List<Tile> mesh = [];

  final List<AnimCube> _animCubes = [];
  final List<SimpleCube> _simpleCubes = [];

  late Undoer _undoer;

  @override
  void initState() {
    getCubeGroupNotifier(context).init(folderPath: 'data', addCubes: _addCubes);
    _undoer = Undoer(_simpleCubes, setState: setState);

    onPanZoomChanged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO instead of clip, use maths to not draw widgets outside screen
    final screen = getScreen(context, listen: false);

    const double buttonsBarHeight = 100;

    return Column(
      children: [
        SizedBox(
          height: screen.height - buttonsBarHeight,
          child: Stack(
            children: [
              UnitToScreen(
                child: Stack(
                  children: [
                    Grid(height: screen.height, scale: getZoomScale(context)),
                    ...mesh,
                    ..._simpleCubes,
                    ..._animCubes,
                  ],
                ),
              ),
              Brush(adoptCubes: _adoptCubes),
              if (Mode.panZoom == getMode(context, listen: true))
                PanZoomer(onPanZoomChanged: onPanZoomChanged),
              // Line(screen.center,screen.center + Offset(screen.width / 4, screen.height / 4)),
            ],
          ),
        ),
        SizedBox(
          height: buttonsBarHeight,
          child: HexagonButtonBar(
            undoer: _undoer,
            saveToClipboard: _saveToClipboard,
          ),
        ),
      ],
    );
  }

  /// once the brush has finished, it
  /// yields ownership of it's cubes to this parent widget.
  /// which then creates a similar list
  /// If we are in add mode
  /// the cubes will end up going
  /// in the simpleCube list once they've animated to full size.
  /// if we're in erase mode they shrink to zero.
  /// either way they get removed from the animCubes array once the
  /// anim is done.
  void _adoptCubes(List<AnimCube> orphans) {
    final bool erase = Mode.erase == getMode(context);

    if (erase) {
      for (final AnimCube cube in orphans) {
        final SimpleCube? simpleCube = _findAt(cube.info.center, _simpleCubes);

        if (simpleCube != null) {
          assert(orphans.length == 1);
          _undoer.save();
          _simpleCubes.remove(simpleCube);
        }
      }
    } else {
      _undoer.save();
    }

    for (final AnimCube cube in orphans) {
      if (cube.scale == (erase ? 0 : 1)) {
        if (!erase) {
          _simpleCubes.add(SimpleCube(info: cube.info));
        }
      } else {
        _animCubes.add(AnimCube(
          key: UniqueKey(),
          info: cube.info,
          start: cube.scale,
          end: erase ? 0.0 : 1.0,
          whenComplete: erase ? _removeSelf : _convertToSimpleCubeAndRemoveSelf,
          duration: 222,
          wire: erase,
        ));
      }
    }
    setState(() {});
  }

  dynamic _removeSelf(AnimCube old) {
    _animCubes.remove(old);
    return () {};
  }

  dynamic _convertToSimpleCubeAndRemoveSelf(AnimCube old) {
    _simpleCubes.add(SimpleCube(info: old.info));
    return _removeSelf(old);
  }

  SimpleCube? _findAt(Position position, List<SimpleCube> list) {
    for (final cube in list) {
      if (position == cube.info.center) {
        return cube;
      }
    }
    return null;
  }

  void _addCubes() {
    List<CubeInfo> cubeInfos = getCubeInfos(context);

    _simpleCubes.clear();
    _animCubes.clear();

    for (int i = 0; i < cubeInfos.length; ++i) {
      _animCubes.add(AnimCube(
        key: UniqueKey(),
        info: cubeInfos[i],
        start: unitPingPong((i % 6) / 6) / 2,
        end: 1.0,
        whenComplete: _convertToSimpleCubeAndRemoveSelf,
      ));
    }

    setState(() {});
    // _saveForUndo();
  }

  void _saveToClipboard() {
    final notifier = getCubeGroupNotifier(context);

    notifier.cubeGroup = CubeGroup(
        List.generate(_simpleCubes.length, (i) => _simpleCubes[i].info));

    Clipboard.setData(ClipboardData(text: notifier.json));
  }

  void onPanZoomChanged() {
    // mesh.c
  }
}
