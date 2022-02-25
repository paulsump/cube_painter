import 'package:cube_painter/buttons/slice_cube_button.dart';
import 'package:cube_painter/data/slice.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/out.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class GestureModeMenu extends StatefulWidget {
  const GestureModeMenu({Key? key}) : super(key: key);

  @override
  State<GestureModeMenu> createState() => _GestureModeMenuState();
}

class _GestureModeMenuState extends State<GestureModeMenu> {
  @override
  Widget build(BuildContext context) {

    const double w = 14;
    const pad = SizedBox(width: w);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
          const Center(child: Text('Slices')),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SliceCubeButton(slice: Slice.topLeft),
              pad,
              SliceCubeButton(slice: Slice.topRight),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SliceCubeButton(slice: Slice.left),
              SizedBox(width: w * 7, child: Icon(DownloadedIcons.plusOutline)),
              // pad,
              // BrushMenuButton(slice: Slice.c),
              // pad,
              SliceCubeButton(slice: Slice.right),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SliceCubeButton(slice: Slice.bottomLeft),
              pad,
              SliceCubeButton(slice: Slice.bottomRight),
            ],
          ),
        ],
      ),
    );
  }
}
