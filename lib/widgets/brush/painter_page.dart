import 'dart:convert';

import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/model/assets.dart';
import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/cube_group.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/cube_store.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/grid_transform.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/widgets/brush/brush.dart';
import 'package:cube_painter/widgets/cubes/anim_cube.dart';
import 'package:cube_painter/widgets/cubes/simple_cube.dart';
import 'package:cube_painter/widgets/scafolding/transformed.dart';
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

  // TODO allow change
  final crop = Crop.dl;

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
        Brush(
          onStartPan: () {},
          onEndPan: _takeCubes,
          onTapUp: _takeCubes,
          erase: false,
          crop: crop,
        ),
        HexagonButton(
          icon: Icons.arrow_back,
          onPressed: () {
            // final zoom = Provider.of<Zoom>(context, listen: false);
            // zoom.increment(1);
            final cubeStore = Provider.of<CubeStore>(context, listen: false);
            cubeStore.increment(-1);
            _simpleCubes.clear();
            _loadCubeGroup();
          },
          center: Offset(2 * x * 1, Y - 2 * y),
          radius: radius,
        ),
        HexagonButton(
          icon: Icons.forward,
          onPressed: () {
            setState(() {
              // final zoom = Provider.of<Zoom>(context, listen: false);
              // zoom.increment(-1);
              final cubeStore = Provider.of<CubeStore>(context, listen: false);
              cubeStore.increment(1);
              _simpleCubes.clear();
              _loadCubeGroup();
              // setState(() {});
            });
          },
          center: Offset(2 * x * 2, Y - 2 * y),
          radius: radius,
        ),
        HexagonButton(
          icon: Icons.save_alt_rounded,
          onPressed: () {
            _updateCurrentCubeGroup();
            Clipboard.setData(ClipboardData(text: _getJson()));
          },
          center: Offset(2 * x * 3, Y - 2 * y),
          radius: radius,
        ),
      ],
    );
  }

  void _takeCubes(List<AnimCube> takenCubes) {
    if (takenCubes.isNotEmpty) {
      // _takeEditBlock();

      final int n = takenCubes.length;

      for (int i = 0; i < n; ++i) {
        //TODO maybe set anim speed
        _animCubes.add(AnimCube(
          key: UniqueKey(),
          info: takenCubes[i].info,
          start: takenCubes[i].scale,
          end: 1.0,
          whenComplete: _convertToSimpleCube,
        ));
      }

      setState(() {});
      // _save();
    }
  }

  dynamic _convertToSimpleCube(AnimCube old) {
    _simpleCubes.add(SimpleCube(info: old.info));
    _animCubes.remove(old);
    return () => 'whatever';
  }

  void _loadAllCubeGroups() async {
    final cubeStore = Provider.of<CubeStore>(context, listen: false);
    await for (final json in Assets.loadAll()) {
      cubeStore.add(CubeGroup.fromJson(await json));
      if (cubeStore.isFirstTime) {
        cubeStore.isFirstTime = false;
        _loadCubeGroup();
        //TODO maybe remove if listing true somewhere?
        setState(() {});
      }
    }
    // cubeStore.notifyListeners();
  }

  void _loadCubeGroup() {
    final cubeStore = Provider.of<CubeStore>(context, listen: false);

    // _createCubesFromGroup(cubeStore);
    for (CubeInfo cubeInfo in cubeStore.getCurrentCubeGroup().list) {
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

    final cubeStore = Provider.of<CubeStore>(context, listen: false);

    for (CubeInfo cubeInfo in cubeStore.getCurrentCubeGroup().list) {
      list.add(cubeInfo);
    }

    final cubeGroup = CubeGroup(list);
    String json = jsonEncode(cubeGroup);
    // out('');
    // out(json);
    // out('');
    return json;
  }

  // _createCubesFromGroup(cubeStore) {
  //   CubeGroup cubeGroup = cubeStore.getCurrentCubeGroup();
  //   for (CubeInfo cubeInfo in cubeGroup.list) {
  //     _simpleCubes.add(SimpleCube(
  //       info: cubeInfo,
  //     ));
  //   }
  // }

  void _updateCurrentCubeGroup() {
    final cubeStore = Provider.of<CubeStore>(context, listen: false);

    final list = cubeStore.getCurrentCubeGroup().list;
    list.clear();

    for (final cube in _simpleCubes) {
      list.add(cube.info);
    }
  }
}

// List<SimpleCube> _createCubesFromGroup2(BuildContext context) {
//   final cubeStore = Provider.of<CubeStore>(context, listen: true);
//   CubeGroup cubeGroup = cubeStore.getCurrentCubeGroup();
//   final cubes = <SimpleCube>[];
//   for (CubeInfo cubeInfo in cubeGroup.list) {
//     cubes.add(SimpleCube(
//       info: cubeInfo,
//     ));
//   }
//   return cubes;
// }
