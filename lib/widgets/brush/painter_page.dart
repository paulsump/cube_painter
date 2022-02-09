import 'dart:convert';

import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/model/assets.dart';
import 'package:cube_painter/model/cube_group.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/notifiers/cube_group_notifier.dart';
import 'package:cube_painter/notifiers/mode_notifier.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/widgets/brush/brush.dart';
import 'package:cube_painter/widgets/cubes/anim_cube.dart';
import 'package:cube_painter/widgets/cubes/simple_cube.dart';
import 'package:cube_painter/widgets/transformed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const noWarn = [out, Screen];

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

  @override
  void initState() {
    _loadAllCubeGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO instead of clip, use maths to not draw widgets outside screen

    const double radius = 40;

    const double x = radius * W;
    const double y = radius * H;

    final Y = Screen.height;
    final modeIcons = [
      Icons.zoom_in_rounded,
      Icons.add,
      Icons.remove,
      Icons.content_cut,
    ];
    // [Icons.pinch_rounded,pan_tool_alt_rounded zoom_in_map_rounded, () => _forward(context)],
    final pressedIconFunks = [
      [Icons.forward, () => _loadNextGroup(context)],
      [Icons.save_alt_rounded, _saveToClipboard],
    ];

    return Stack(
      children: [
        Transformed(
          child: Stack(
            children: [
              ..._simpleCubes,
              ..._animCubes,
            ],
          ),
        ),
        Brush(takeCubes: _adoptCubes),
        for (int i = 0; i < 4; ++i)
          HexagonButton(
            icon: modeIcons[i],
            mode: Mode.values[i],
            center: Offset(2 * x * i + x / 2, Y - 2 * y),
            radius: radius,
          ),
        for (int i = 0; i < 2; ++i)
          HexagonButton(
            icon: pressedIconFunks[i][0] as IconData,
            onPressed: pressedIconFunks[i][1] as VoidCallback,
            center: Offset(2 * x * (4 + i) + x / 2, Y - 2 * y),
            radius: radius,
          ),
      ],
    );
  }

  void _loadNextGroup(BuildContext context) {
    // final zoom = Provider.of<Zoom>(context, listen: false);
    // zoom.increment(-1);

    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);
    cubeGroupNotifier.increment(1);

    _simpleCubes.clear();
    _loadCubeGroup();

    setState(() {});
  }

  void _adoptCubes(List<AnimCube> takenCubes) {
    final bool erase =
        Mode.erase == Provider.of<ModeNotifier>(context, listen: false).mode;

    if (erase) {
      for (final AnimCube cube in takenCubes) {
        final SimpleCube? simpleCube = _findAt(cube.info.center, _simpleCubes);

        if (simpleCube != null) {
          _simpleCubes.remove(simpleCube);
        }
      }
    }

    if (takenCubes.isNotEmpty) {
      for (final cube in takenCubes) {
        //TODO maybe set anim duration
        _animCubes.add(AnimCube(
          key: UniqueKey(),
          info: cube.info,
          start: cube.scale,
          end: erase ? 0.0 : 1.0,
          whenComplete: erase ? _doNothing : _convertToSimpleCube,
          // whenComplete: _convertToSimpleCube,
        ));
      }

      setState(() {});
    }
  }

  dynamic _doNothing(AnimCube old) {
    return () {};
  }

  dynamic _convertToSimpleCube(AnimCube old) {
    _simpleCubes.add(SimpleCube(info: old.info));
    _animCubes.remove(old);
    return () {};
  }

  SimpleCube? _findAt(GridPoint position, List<SimpleCube> list) {
    for (final cube in list) {
      if (position == cube.info.center) {
        return cube;
      }
    }
    return null;
  }

  void _loadAllCubeGroups() async {
    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    await for (final json in Assets.loadAll()) {
      cubeGroupNotifier.add(CubeGroup.fromJson(await json));
      if (cubeGroupNotifier.isFirstTime) {
        cubeGroupNotifier.isFirstTime = false;
        _loadCubeGroup();
        //TODO maybe remove if listing true somewhere?
        setState(() {});
      }
    }
    // cubeGroupNotifier.notifyListeners();
  }

  void _loadCubeGroup() {
    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    // _createCubesFromGroup(cubeGroupNotifier);
    for (CubeInfo cubeInfo in cubeGroupNotifier.getCurrentCubeGroup().list) {
      _animCubes.add(AnimCube(
        key: UniqueKey(),
        info: cubeInfo,
        start: 0,
        end: 1.0,
        whenComplete: _convertToSimpleCube,
      ));
    }
  }

  String _getJson() {
    final list = <CubeInfo>[];

    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    for (CubeInfo cubeInfo in cubeGroupNotifier.getCurrentCubeGroup().list) {
      list.add(cubeInfo);
    }

    final cubeGroup = CubeGroup(list);
    String json = jsonEncode(cubeGroup);
    // out('');
    // out(json);
    // out('');
    return json;
  }

  void _saveToClipboard() {
    _updateCurrentCubeGroup();
    Clipboard.setData(ClipboardData(text: _getJson()));
  }

  void _updateCurrentCubeGroup() {
    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    final list = cubeGroupNotifier.getCurrentCubeGroup().list;
    list.clear();

    for (final cube in _simpleCubes) {
      list.add(cube.info);
    }
  }
}
