import 'package:cube_painter/buttons/crop_cube_button.dart';
import 'package:cube_painter/buttons/cube_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/downloaded_icons.dart';
import 'package:cube_painter/gesture_mode.dart';
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
    final gestureMode = getGestureMode(context, listen: true);

    const double w = 14;
    const pad = SizedBox(width: w);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10.0 + MediaQuery.of(context).padding.top),
          const Center(child: Text('Brush Modes')),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CropCubeButton(crop: Crop.dr),
              pad,
              CropCubeButton(crop: Crop.dl),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CropCubeButton(crop: Crop.r),
              pad,
              CubeButton(
                radioOn: GestureMode.erase == gestureMode,
                icon: DownloadedIcons.cancelOutline,
                iconSize: downloadedIconSize,
                onPressed: () {
                  setGestureMode(GestureMode.erase, context);
                },
                tip:
                    'Tap on a cube to delete it.  You can change the position while you have your finger down.',
              ),
              pad,
              const CropCubeButton(crop: Crop.l),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CropCubeButton(crop: Crop.ur),
              pad,
              CropCubeButton(crop: Crop.ul),
            ],
          ),
        ],
      ),
    );
  }
}
