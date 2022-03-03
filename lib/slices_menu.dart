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
    final shortestEdge = getShortestEdge(context);

    final double padWidth = 0.01 * shortestEdge;
    final padX = SizedBox(width: padWidth);

    final double padHeight = 0.03247 * shortestEdge;
    final padY = SizedBox(height: padHeight);

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
              children: [
                const SliceCubeButton(slice: Slice.topLeft),
                padX,
                const SliceCubeButton(slice: Slice.topRight),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SliceCubeButton(slice: Slice.left),
                // SizedBox(
                //     width:
                //         padWidth * 2 + 67,
                //     child: const Icon(AssetIcons.plusOutline)),
                padX,
                const SliceCubeButton(slice: Slice.whole),
                padX,
                const SliceCubeButton(slice: Slice.right),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SliceCubeButton(slice: Slice.bottomLeft),
                padX,
                const SliceCubeButton(slice: Slice.bottomRight),
              ],
            ),
            if (isPortrait) Center(child: _SlicesExample(padHeight: padHeight)),
          ],
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
    final length = getShortestEdge(context);

    final offsetY = 0.32251 * length;
    final scale = 0.42857 * length;

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
                ),
                Thumbnail(
                  painting: paintingBank.slicesExample.triangleGap,
                  unitTransform: paintingBank.slicesExample.unitTransform,
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
