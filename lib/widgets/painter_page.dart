import 'dart:convert';

import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/mode.dart';
import 'package:cube_painter/model/assets.dart';
import 'package:cube_painter/model/crop.dart';
import 'package:cube_painter/model/cube_group.dart';
import 'package:cube_painter/model/cube_group_notifier.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/transform/unit_ping_pong.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/transform/zoom_pan.dart';
import 'package:cube_painter/widgets/brush/brush.dart';
import 'package:cube_painter/widgets/cubes/anim_cube.dart';
import 'package:cube_painter/widgets/cubes/simple_cube.dart';
import 'package:cube_painter/widgets/cubes/unit_cube.dart';
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

    const double x = 2 * radius * W;
    final double y = Screen.height - 2 * radius * H;

    final Crop crop = Provider.of<CropNotifier>(context, listen: true).crop;

    final unitCubesForModes = [
      null,
      const UnitCube(crop: Crop.c),
      const UnitCube(crop: Crop.c, style: PaintingStyle.stroke),
      UnitCube(crop: crop),
    ];

    final pressedIconFunks = [
      [Icons.forward, () => _loadNextGroup(context)],
      [Icons.save_alt_rounded, _saveToClipboard],
    ];

    return Stack(
      children: [
        UnitToScreen(
          child: Stack(
            children: [
              ..._simpleCubes,
              ..._animCubes,
            ],
          ),
        ),
        Brush(adoptCubes: _adoptCubes),
        HexagonButton(
          icon: Icons.zoom_in_rounded,
          mode: Mode.panZoom,
          center: Offset(x * 0.5, y),
          radius: radius,
        ),
        for (int i = 1; i < 4; ++i)
          HexagonButton(
            unitChild: unitCubesForModes[i],
            mode: Mode.values[i],
            center: Offset(x * (i + 0.5), y),
            radius: radius,
            onPressed: i == 1
                ? () {
                    /// TODO get working
                    /// TODO set by gestures
              final zoom =
                        Provider.of<PanZoomNotifier>(context, listen: false);
                    zoom.increment(-1);
                    setState(() {});
                  }
                : i == 3
                    ? () {
                        final cropNotifier =
                            Provider.of<CropNotifier>(context, listen: false);
                        cropNotifier.increment(-1);
                      }
                    : null,
          ),
        for (int i = 0; i < 2; ++i)
          HexagonButton(
            icon: pressedIconFunks[i][0] as IconData,
            onPressed: pressedIconFunks[i][1] as VoidCallback,
            center: Offset(x * (i + 4.5), y),
            radius: radius,
          ),
        for (int i = 0; i < 7; ++i)
          Hexagon(center: Offset(x * i, y + 3 * radius * H), radius: radius),
      ],
    );
  }

  void _loadNextGroup(BuildContext context) {
    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    cubeGroupNotifier.increment(1);
    _simpleCubes.clear();

    _loadCubeGroup();
    setState(() {});
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
          _simpleCubes.remove(simpleCube);
        }
      }
    }

    if (orphans.isNotEmpty) {
      for (final cube in orphans) {
        //TODO maybe set anim duration
        _animCubes.add(AnimCube(
          key: UniqueKey(),
          info: cube.info,
          start: cube.scale,
          end: erase ? 0.0 : 1.0,
          whenComplete: erase ? _removeSelf : _convertToSimpleCubeAndRemoveSelf,
        ));
      }

      setState(() {});
    }
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

  void _loadAllCubeGroups() async {
    final cubeGroupNotifier =
        Provider.of<CubeGroupNotifier>(context, listen: false);

    await for (final json in Assets.loadAll()) {
      cubeGroupNotifier.add(CubeGroup.fromJson(await json));

      if (cubeGroupNotifier.isFirstTime) {
        cubeGroupNotifier.isFirstTime = false;
        _loadCubeGroup();
        //TODO maybe remove if "CubeGroupNotifier listen: true" somewhere?
        setState(() {});
      }
    }
    // cubeGroupNotifier.notifyListeners();
  }

  void _loadCubeGroup() {
    List<CubeInfo> list = getCubeGroupList(context);
    final int n = list.length;

    for (int i = 0; i < n; ++i) {
      _animCubes.add(AnimCube(
        key: UniqueKey(),
        info: list[i],
        start: unitPingPong((i % 6) / 6) / 2,
        end: 1.0,
        whenComplete: _convertToSimpleCubeAndRemoveSelf,
      ));
    }
  }

  String _getJson() {
    final list = <CubeInfo>[];

    for (CubeInfo cubeInfo in getCubeGroupList(context)) {
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
    List<CubeInfo> list = getCubeGroupList(context);
    list.clear();

    for (final cube in _simpleCubes) {
      list.add(cube.info);
    }
  }
}
