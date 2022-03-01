import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/brush/gesture_handler.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

/// Handle gestures, passing them to [Brush] or [PanZoomer].
class Gesturer extends StatefulWidget {
  const Gesturer({Key? key}) : super(key: key);

  @override
  State<Gesturer> createState() => GesturerState();
}

class GesturerState extends State<Gesturer> {
  final GestureHandler gestureHandler = Brush();

  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          // HACK without this container,
          // onScaleStart etc doesn't get called after cubes are added.
          Container(),
        ],
      ),
      onScaleStart: (details) {
        // if tapped, use that fromPosition since it's where the user started, and therefore better
        if (!tapped) {
          gestureHandler.start(details.focalPoint, context);
        }
      },
      onScaleUpdate: (details) {
        gestureHandler.update(details.focalPoint, context);
      },
      onScaleEnd: (details) {
        tapped = false;
        gestureHandler.end(context);
      },
      onTapDown: (details) {
        tapped = true;
        gestureHandler.tapDown(details.localPosition, context);
      },
      onTapUp: (details) {
        tapped = false;
        gestureHandler.tapUp(details.localPosition, context);
      },
    );
  }
}
