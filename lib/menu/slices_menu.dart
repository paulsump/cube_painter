import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/assets.dart';
import 'package:cube_painter/persisted/sketch.dart';
import 'package:cube_painter/persisted/slice.dart';
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
            const Center(
              child: Text('Slices are used to create'),
            ),
            const Center(
              child: Text('impossible Escher-like'),
            ),
            const Center(
              child: Text('structures like this...'),
            ),
            padY,
            const Center(child: _Example()),
          ],
        ),
      ),
    );
  }
}

class _Example extends StatefulWidget {
  const _Example({Key? key}) : super(key: key);

  @override
  State<_Example> createState() => _ExampleState();
}

class _ExampleState extends State<_Example> {
  Sketch? _triangleWithGap;

  Sketch? _triangleGap;

  @override
  void initState() {
    _loadAssets();

    super.initState();
  }

  Future<void> _loadAssets() async {
    final assets = await Assets.getStrings('help/triangle_');

    _triangleWithGap = Sketch.fromString(assets['triangle_with_gap.json']!);
    _triangleGap = Sketch.fromString(assets['triangle_gap.json']!);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 99),
      child: Transform.scale(
        scale: 111,
        child: Stack(
          children: [
            if (_triangleWithGap != null)
              Thumbnail(
                sketch: _triangleWithGap!,
                unitTransform:
                    calcUnitScaleAndOffset(_triangleWithGap!.cubeInfos),
              ),
            if (_triangleWithGap != null && _triangleGap != null)
              //TODO _AnimThumbnail
              Thumbnail(
                sketch: _triangleGap!,
                unitTransform:
                    calcUnitScaleAndOffset(_triangleWithGap!.cubeInfos),
              ),
            if (_triangleWithGap == null && _triangleGap == null)
              Container(color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
