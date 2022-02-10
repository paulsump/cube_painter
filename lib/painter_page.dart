import 'dart:convert';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/cubes/unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_group_notifier.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/grid_point.dart';
import 'package:cube_painter/grid.dart';
import 'package:cube_painter/line.dart';
import 'package:cube_painter/mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_ping_pong.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/transform/zoom_pan.dart';
import 'package:cube_painter/undoer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const noWarn = [out, getScreen];

class PainterPage extends StatefulWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final List<AnimCube> _animCubes = [];
  final List<SimpleCube> _simpleCubes = [];

  late Undoer _undoer;

  @override
  void initState() {
    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    cubeGroupNotifier.init(folderPath: 'data', whenComplete: _addCubeGroup);
    _undoer = Undoer(_simpleCubes);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO instead of clip, use maths to not draw widgets outside screen

    const double radius = 40;

    const double x = 2 * radius * W;
    final double y = getScreen(context, listen: true).height - 2 * radius * H;

    final Crop crop = Provider.of<CropNotifier>(context, listen: true).crop;

    final unitCubesForModes = [
      null,
      const UnitCube(crop: Crop.c),
      const UnitCube(crop: Crop.c, style: PaintingStyle.stroke),
      UnitCube(crop: crop),
    ];

    final buttonInfo = [
      [true, Icons.forward, () => _loadNextGroup()],
      [
        _undoer.canUndo,
        Icons.undo_sharp,
        () => {_undoer.undo(), setState(() {})}
      ],
      [
        _undoer.canRedo,
        Icons.redo_sharp,
        () => {_undoer.redo(), setState(() {})}
      ],
      [true, Icons.save_alt_sharp, _saveToClipboard],
    ];

    return Stack(
      children: [
        UnitToScreen(
          child: Stack(
            children: [
              const Grid(),
              ..._simpleCubes,
              ..._animCubes,
            ],
          ),
        ),
        Brush(adoptCubes: _adoptCubes),
        // const PanZoomer(),
        HexagonButton(
            icon: Icons.zoom_in_rounded,
            mode: Mode.panZoom,
            center: Offset(x * 0.5, y),
            radius: radius,
            onPressed: () {
              // TODO set by gestures
              final zoom = Provider.of<PanZoomNotifier>(context, listen: false);
              zoom.increment(-1);
              setState(() {});
            }),
        for (int i = 1; i < unitCubesForModes.length; ++i)
          HexagonButton(
            unitChild: unitCubesForModes[i],
            icon: i == 2 ? Icons.highlight_remove_sharp : null,
            mode: Mode.values[i],
            center: Offset(x * (i + 0.5), y),
            radius: radius,
            onPressed: i == 3
                ? () {
                    final cropNotifier =
                        Provider.of<CropNotifier>(context, listen: false);
                    cropNotifier.increment(-1);
                  }
                : null,
          ),
        for (int i = 0; i < buttonInfo.length; ++i)
          HexagonButton(
            enabled: buttonInfo[i][0] as bool,
            icon: buttonInfo[i][1] as IconData,
            onPressed: buttonInfo[i][2] as VoidCallback,
            center: Offset(x * (i + 4.5), y),
            radius: radius,
          ),
        for (int i = 0; i < 8; ++i)
          Hexagon(center: Offset(x * i, y + 3 * radius * H), radius: radius),
        Line(Offset.zero, getScreen(context, listen: true).rect.bottomRight),
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
        _simpleCubes.add(SimpleCube(info: cube.info));
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

  SimpleCube? _findAt(GridPoint position, List<SimpleCube> list) {
    for (final cube in list) {
      if (position == cube.info.center) {
        return cube;
      }
    }
    return null;
  }

  void _loadNextGroup() {
    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    cubeGroupNotifier.increment(1);
    _addCubeGroup();
  }

  void _addCubeGroup() {
    List<CubeInfo> list = getCubeInfos(context);

    _simpleCubes.clear();
    _animCubes.clear();

    for (int i = 0; i < list.length; ++i) {
      _animCubes.add(AnimCube(
        key: UniqueKey(),
        info: list[i],
        start: unitPingPong((i % 6) / 6) / 2,
        end: 1.0,
        whenComplete: _convertToSimpleCubeAndRemoveSelf,
      ));
    }

    setState(() {});
    // _saveForUndo();
  }

  ///
  void _saveToClipboard() {
    _updateCurrentCubeGroup();
    Clipboard.setData(ClipboardData(text: _getJson()));
  }

  /// For saving to clipboard
  //TODO FIX FOR Simple cubes and crops
  void _updateCurrentCubeGroup() {
    List<CubeInfo> list = getCubeInfos(context);
    list.clear();

    for (final cube in _simpleCubes) {
      //modify directly so that we don't notify until end
      list.add(cube.info);
    }
  }

  /// For saving to clipboard
  String _getJson() {
    final list = <CubeInfo>[];

    for (CubeInfo cubeInfo in getCubeInfos(context)) {
      list.add(cubeInfo);
    }

    final cubeGroup = CubeGroup(list);
    String json = jsonEncode(cubeGroup);
    // out('');
    // out(json);
    // out('');
    return json;
  }
}
