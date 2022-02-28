import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/out.dart';
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

class _AnimThumbnail extends StatelessWidget {
  const _AnimThumbnail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
