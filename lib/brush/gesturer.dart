import 'package:cube_painter/brush/brush.dart';
import 'package:cube_painter/brush/gesture_handler.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/persisted/position.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:flutter/material.dart';

const noWarn = [out, Position];

/// Handle gestures, passing them to [Brush] or [PanZoomer].
class Gesturer extends StatefulWidget {
  const Gesturer({Key? key}) : super(key: key);

  @override
  State<Gesturer> createState() => GesturerState();
}

class GesturerState extends State<Gesturer> {
  final GestureHandler panZoomer = PanZoomer();

  final Brush brush = Brush();
  late GestureHandler gestureHandler;

  bool tapped = false;
  int n = 0;
  double totalScale = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // without this container,  onScaleStart etc doesn't get called
      // child: Container(),
      onScaleStart: (details) {
        n = 0;
        totalScale = 0;

        // if tapped, use that fromPosition since it's where the user started, and therefore better
        if (!tapped) {
          gestureHandler = panZoomer;

          brush.start(details.focalPoint, context);
          panZoomer.start(details.focalPoint, context);
        }
      },
      onScaleUpdate: (details) {
        n++;

        totalScale += details.scale;

        if (n > 9) {
          if (totalScale / n == 1 && gestureHandler != brush) {
            gestureHandler = brush;
          }
          gestureHandler.update(details.focalPoint, details.scale, context);
        }
      },
      onScaleEnd: (details) {
        tapped = false;
        gestureHandler.end(context);
      },
      // onTapDown: (details) {
      //   tapped = true;
      //   gestureHandler = brush;
      //
      //   gestureHandler.tapDown(details.localPosition, context);
      //   panZoomer.start(details.localPosition, context);
      // },
      // onTapUp: (details) {
      //   tapped = false;
      //   gestureHandler.tapUp(details.localPosition, context);
      // },
    );
  }
}
