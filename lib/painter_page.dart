import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/buttons/hexagon.dart';
import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/buttons/hexagon_button_bar.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/anim_cube.dart';
import 'package:cube_painter/cubes/simple_cube.dart';
import 'package:cube_painter/cubes/unit_cube.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/data/cube_info.dart';
import 'package:cube_painter/data/position.dart';
import 'package:cube_painter/grid.dart';
import 'package:cube_painter/line.dart';
import 'package:cube_painter/mode.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/tile.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/pan_zoomer.dart';
import 'package:cube_painter/transform/position_to_unit.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:cube_painter/undoer.dart';
import 'package:cube_painter/unit_ping_pong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const noWarn = [out, getScreen, Line, PanZoomer];

class PainterPage extends StatefulWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PainterPage> createState() => _PainterPageState();
}

class _PainterPageState extends State<PainterPage> {
  final List<Tile> gridTiles = [];

  final List<AnimCube> _animCubes = [];
  final List<SimpleCube> _simpleCubes = [];

  late Undoer _undoer;

  @override
  void initState() {
    getCubeGroupNotifier(context).init(folderPath: 'data', addCubes: _addCubes);
    _undoer = Undoer(_simpleCubes, setState: setState);

    // _tiles = createTiles
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO instead of clip, use maths to not draw widgets outside screen

    final screen = getScreen(context, listen: true);
    const double radius = 40;

    const double x = 2 * radius * W;
    final double y = screen.height - 2 * radius * H;

    final Crop crop = Provider.of<CropNotifier>(context, listen: true).crop;

    final modeButtonInfo = [
      [],
      [Icons.add, const UnitCube(crop: Crop.c)],
      [Icons.remove, const UnitCube(crop: Crop.c, style: PaintingStyle.stroke)],
      [Icons.add, UnitCube(crop: crop)],
    ];

    final otherButtonInfo = [
      [_undoer.canUndo, Icons.undo_sharp, _undoer.undo],
      [_undoer.canRedo, Icons.redo_sharp, _undoer.redo],
      [true, Icons.forward, () => getCubeGroupNotifier(context).increment(1)],
      [true, Icons.save_alt_sharp, _saveToClipboard],
    ];
    return Stack(
      children: [
        UnitToScreen(
          child: Stack(
            children: [
              Grid(height: screen.height, scale: getZoomScale(context)),
              ...gridTiles,
              ..._simpleCubes,
              ..._animCubes,
            ],
          ),
        ),
        Brush(adoptCubes: _adoptCubes),
        if (Mode.panZoom == getMode(context))
          PanZoomer(onPanZoomChanged: onPanZoomChanged),
        const HexagonButtonBar(),
        HexagonButton(
          icon: Icons.zoom_in_rounded,
          mode: Mode.panZoom,
          center: Offset(x * 0.5, y),
          radius: radius,
        ),
        for (int i = 1; i < modeButtonInfo.length; ++i)
          HexagonButton(
            icon: modeButtonInfo[i][0] as IconData,
            iconOffset: const Offset(W, H) * -radius * 0.5,
            unitChild: modeButtonInfo[i][1] as UnitCube,
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
        for (int i = 0; i < otherButtonInfo.length; ++i)
          HexagonButton(
            enabled: otherButtonInfo[i][0] as bool,
            icon: otherButtonInfo[i][1] as IconData,
            onPressed: otherButtonInfo[i][2] as VoidCallback,
            center: Offset(x * (i + 4.5), y),
            radius: radius,
          ),
        for (int i = 0;
            i < 1 + modeButtonInfo.length + otherButtonInfo.length;
            ++i)
          Hexagon(
              center: Offset(x * i, y + 3 * radius * H),
              radius: radius,
              color: buttonColor),
        // Line(screen.origin,screen.origin+Offset(screen.width/4,screen.height/4)),
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

  ///
  void _saveToClipboard() {
    final notifier = getCubeGroupNotifier(context);
    notifier.cubeGroup = CubeGroup(
        List.generate(_simpleCubes.length, (i) => _simpleCubes[i].info));

    Clipboard.setData(ClipboardData(text: notifier.json));
  }

  void onPanZoomChanged() {
    //TODO UPdate gridTiles
  }
}
