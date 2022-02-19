import 'dart:ui';

import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cubes.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/cubes/tiles.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/menu.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [
  out,
  getScreen,
  PanZoomer,
  lerpDouble,
  positionToUnitOffset,
  Tiles,
  HexagonButtonBar,
  getCubeInfos,
  StaticCubes,
];

class PainterPage extends StatefulWidget {
  const PainterPage({Key? key}) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final _cubes = Cubes();

  @override
  void initState() {
    _cubes.init(setState_: setState, context_: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = getScreen(context, listen: true);

    final cubeInfos = getCubeInfos(context, listen: true);
    final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

    const double barHeight = 77;
    const double buttonHeight = barHeight + 22;

    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        toolbarHeight: barHeight,
        title: const Text("Cube Painter"),
        backgroundColor: backgroundColor,
        actions: <Widget>[
          HexagonButton(
            height: buttonHeight,
            child: const Icon(Icons.shopping_cart), // enabled: info.enabled,
            onPressed: () {},
            // icon: Icons.shopping_cart,
            // center: Offset(222,20),
            // radius: 20,
          ),
          HexagonButton(
            height: buttonHeight,
            child: const Text('hi'), // enabled: info.enabled,
            onPressed: () {},
            // icon: Icons.shopping_cart,
            // center: Offset(222,20),
            // radius: 20,
          ),
        ],
      ),
      drawer: Menu(
        items: <MenuItem>[
          MenuItem(text: 'Clear', icon: Icons.star, callback: () {}),
          MenuItem(
            text: 'Forward',
            icon: Icons.forward,
            callback: getCubeGroupNotifier(context).forward,
          ),
          MenuItem(
            text: 'Save to clipboard',
            icon: Icons.save_alt_sharp,
            callback: _cubes.saveToClipboard,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          UnitToScreen(
            child: Stack(
              children: [
                const Tiles(),
                StaticCubes(cubeInfos: cubeInfos),
                ..._cubes.animCubes,
              ],
            ),
          ),
          GestureMode.panZoom == getGestureMode(context, listen: true)
              ? const PanZoomer()
              : Brush(adoptCubes: _cubes.adopt),
          HexagonButtonBar(
              undoer: _cubes.undoer,
              saveToClipboard: _cubes.saveToClipboard,
              screen: screen,
              scaffoldState: scaffoldState),
        ]),
      ),
    );
  }
}
