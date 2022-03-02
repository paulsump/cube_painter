import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/sketch_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// A drawer with radio buttons for
/// choosing which cube [Slice] to add.
/// There's also an example of how to use them.
class SlicesMenu extends StatefulWidget {
  const SlicesMenu({Key? key}) : super(key: key);

  @override
  State<SlicesMenu> createState() => _SlicesMenuState();
}

const double _padHeight = 15.0;
const padY = SizedBox(height: _padHeight);

class _SlicesMenuState extends State<SlicesMenu> {
  @override
  Widget build(BuildContext context) {
    const double padWidth = 14;
    const padX = SizedBox(width: padWidth);

    final screen = getScreenSize(context);
    final bool isPortrait = screen.width < screen.height;

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
                    width: padWidth * 7, child: Icon(AssetIcons.plusOutline)),
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
            if (isPortrait) const Center(child: _Example()),
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

    return Column(
      children: [
        const SizedBox(height: _padHeight * 4),
        const Text('Slices are used to create'),
        const Text('impossible Escher-like'),
        const Text('structures like this...'),
        padY,
        Transform.translate(
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
        ),
      ],
    );
  }
}
