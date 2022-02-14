import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/cubes/simple_tile.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/line.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/undoer.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const noWarn = [
  out,
  getScreen,
  Line,
  PanZoomer,
  lerpDouble,
  positionToUnitOffset,
  SimpleTile,
];

class PainterPage extends StatefulWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final List<SimpleTile> _tiles = [];

  final List<AnimCube> _animCubes = [];
  final List<SimpleCube> _simpleCubes = [];

  late Undoer _undoer;

  @override
  void initState() {
    getCubeGroupNotifier(context).init(folderPath: 'data', addCubes: _addCubes);
    _undoer = Undoer(_simpleCubes, setState: setState);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = getScreen(context, listen: true);

    if (screen.height != 0 && _tiles.isEmpty) {
      _rebuildTiles();
    }

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
                    ..._tiles,
                    ..._simpleCubes,
                    ..._animCubes,
                  ],
                ),
              ),
              Brush(adoptCubes: _adoptCubes),
              if (GestureMode.panZoom == getGestureMode(context, listen: true))
                PanZoomer(
                  onPanZoomUpdate: _rebuildTiles,
                  onPanZoomEnd: _rebuildTiles,
                ),
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
  /// If we are in add gestureMode
  /// the cubes will end up going
  /// in the simpleCube list once they've animated to full size.
  /// if we're in erase gestureMode they shrink to zero.
  /// either way they get removed from the animCubes array once the
  /// anim is done.
  void _adoptCubes(List<AnimCube> orphans) {
    final bool erase = GestureMode.erase == getGestureMode(context);

    if (erase) {
      for (final AnimCube cube in orphans) {
        final SimpleCube? simpleCube = _getCubeAt(cube.info.center);

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

  SimpleCube? _getCubeAt(Position position) {
    for (final cube in _simpleCubes) {
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
  }

  void _saveToClipboard() {
    final notifier = getCubeGroupNotifier(context);

    notifier.cubeGroup = CubeGroup(
        List.generate(_simpleCubes.length, (i) => _simpleCubes[i].info));

    Clipboard.setData(ClipboardData(text: notifier.json));
  }

  void _rebuildTiles() {
    _tiles.clear();

    final screen = getScreen(context, listen: false);
    final double scale = getZoomScale(context);

    final Offset panOffset = getPanOffset(context, listen: false) / scale;
    final Offset center = screen.center / scale;

    final double NX = screen.width / scale;
    final int nx = NX.ceil() + 3;

    final double remainderX = panOffset.dx % W;
    double panX = panOffset.dx - remainderX;

    if ((panX / W) % 2 != 0) {
      panX -= W;
    }

    final double remainderY = panOffset.dy % H;
    double panY = panOffset.dy - remainderY;

    if ((panY / H) % 2 != 0) {
      panY -= H;
    }

    final double NY = screen.height / scale;
    final int ny = NY.ceil();

    for (int x = -3; x < nx + 2; ++x) {
      for (int y = -6; y < ny + 1; ++y) {
        final double h = x % 2 == 0 ? 0 : H;

        double Y = h + y.toDouble();
        double X = W * x.toDouble();

        X -= panX;
        Y -= panY;

        X -= center.dx - center.dx % W;
        Y -= center.dy - center.dy % H;

        _tiles.add(SimpleTile(bottom: Offset(X, Y)));
      }
    }
    setState(() {});
  }
}
