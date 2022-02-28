import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/cubes/static_cube.dart';
import 'package:cube_painter/persisted/assets.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class SlicesMenu extends StatefulWidget {
  const SlicesMenu({Key? key}) : super(key: key);

  @override
  State<SlicesMenu> createState() => _SlicesMenuState();
}

class _SlicesMenuState extends State<SlicesMenu> {
  @override
  Widget build(BuildContext context) {
    const double w = 14;
    const padX = SizedBox(width: w);
    const padY = SizedBox(height: 15.0);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            padY,
            const Center(child: Text('Slices')),
            padY,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SliceCubeButton(slice: Slice.topLeft),
                padX,
                SliceCubeButton(slice: Slice.topRight),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SliceCubeButton(slice: Slice.left),
                SizedBox(
                    width: w * 7, child: Icon(DownloadedIcons.plusOutline)),
                // padX,
                // BrushMenuButton(slice: Slice.c),
                // padX,
                SliceCubeButton(slice: Slice.right),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SliceCubeButton(slice: Slice.bottomLeft),
                padX,
                SliceCubeButton(slice: Slice.bottomRight),
              ],
            ),
            padY,
            const Text(
                'Slices are used to create impossible Escher like structures like this...'),
            padY,
            const _AnimThumbnail(),
          ],
        ),
      ),
    );
  }
}

class _AnimThumbnail extends StatefulWidget {
  const _AnimThumbnail({Key? key}) : super(key: key);

  @override
  State<_AnimThumbnail> createState() => _AnimThumbnailState();
}

class _AnimThumbnailState extends State<_AnimThumbnail> {
  Sketch? _triangle_with_gap;

  Sketch? _triangle_gap;

  @override
  void initState() {
    _loadAssets();

    super.initState();
  }

  Future<void> _loadAssets() async {
    final assets = await Assets.getStrings('help/triangle_');
    _triangle_with_gap = Sketch.fromString(assets['triangle_with_gap.json']!);
    _triangle_gap = Sketch.fromString(assets['triangle_gap.json']!);
  }

  @override
  Widget build(BuildContext context) {
    return UnitToScreen(
      child: Stack(
        children: [
          if (_triangle_with_gap != null)
            StaticCubes(sketch: _triangle_with_gap!),
          if (_triangle_with_gap != null)
            StaticCubes(sketch: _triangle_with_gap!),
          Container(),
        ],
      ),
    );
  }
}
