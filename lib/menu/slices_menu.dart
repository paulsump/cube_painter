import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
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
            padY,
            padY,
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

class _Example extends StatelessWidget {
  const _Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sketchBank = getSketchBank(context);

    return Transform.translate(
      /// TODO Responsive to screen size- magic numbers
      offset: const Offset(0, 149),
      child: Transform.scale(
        /// TODO Responsive to screen size- magic numbers
        scale: 211,
        child: Stack(
          children: [
            Thumbnail(
              sketch: sketchBank.example.triangleWithGap,
              unitTransform: sketchBank.example.unitTransform,
            ),
              Thumbnail(
              sketch: sketchBank.example.triangleGap,
              unitTransform: sketchBank.example.unitTransform,
            ),
            // Container(color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
