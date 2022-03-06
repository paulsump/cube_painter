import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/buttons/thumbnail.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/persisted/slice.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

const noWarn = out;

/// A drawer with radio buttons for
/// choosing which cube [Slice] to add.
/// There's also an example of how to use them.
class SlicesMenu extends StatelessWidget {
  const SlicesMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double padHeight = screenAdjust(0.03247, context);

    final screen = getScreenSize(context);
    final bool isPortrait = screen.width < screen.height;

    final safeRight = MediaQuery.of(context).padding.right;
    return SizedBox(
      width: screenAdjust(0.6, context) + safeRight / 6,
      child: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: padHeight),
              const Center(child: Text('Slices')),
              SizedBox(height: padHeight * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SliceCubeButton(slice: Slice.topLeft),
                  SliceCubeButton(slice: Slice.topRight),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SliceCubeButton(slice: Slice.left),
                  SliceCubeButton(slice: Slice.whole),
                  SliceCubeButton(slice: Slice.right),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SliceCubeButton(slice: Slice.bottomLeft),
                  SliceCubeButton(slice: Slice.bottomRight),
                ],
              ),
              if (isPortrait)
                Center(child: _SlicesExample(padHeight: padHeight)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlicesExample extends StatelessWidget {
  final double padHeight;

  const _SlicesExample({Key? key, required this.padHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paintingBank = getPaintingBank(context);

    final padY = SizedBox(height: padHeight);

    final offsetY = screenAdjust(0.32251, context);
    final scale = screenAdjust(0.42857, context);

    return Column(
      children: [
        SizedBox(height: padHeight * 4),
        const Text('Slices are used to create'),
        const Text('impossible Escher-like'),
        const Text('structures like this...'),
        padY,
        Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: scale,
            child: Stack(
              children: [
                Thumbnail(
                  painting: paintingBank.slicesExample.triangleWithGap,
                  unitTransform: paintingBank.slicesExample.unitTransform,
                  isPingPong: false,
                ),
                Thumbnail(
                  painting: paintingBank.slicesExample.triangleGap,
                  unitTransform: paintingBank.slicesExample.unitTransform,
                  isPingPong: true,
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
