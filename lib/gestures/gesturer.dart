import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/gestures/gesture_handler.dart';
import 'package:cube_painter/gestures/pan_zoom.dart';
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
  final GestureHandler panZoomer = PanZoomer();

  final Brush brush = Brush();
  late GestureHandler gestureHandler;

  bool tapped = false;
  Offset tapPoint = Offset.zero;

  int n = 0;
  double totalScale = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        n = 0;
        totalScale = 0;

        gestureHandler = panZoomer;
        panZoomer.start(details.focalPoint, context);

        // if tapped, use that fromPosition since it's where the user started, and therefore better
        if (!tapped) {
          brush.start(details.focalPoint, context);
        }
      },
      onScaleUpdate: (details) {
        n++;

        totalScale += details.scale;

        if (n > 9) {
          if (totalScale / n == 1 && gestureHandler != brush) {
            gestureHandler = brush;

            if (tapped) {
              brush.start(tapPoint, context);
            }
          }
          gestureHandler.update(details.focalPoint, details.scale, context);
        }
      },
      onScaleEnd: (details) {
        tapped = false;
        gestureHandler.end(context);
      },
      onTapDown: (details) {
        tapped = true;

        gestureHandler = panZoomer;
        tapPoint = details.localPosition;
      },
      onTapUp: (details) {
        tapped = false;

        gestureHandler.tapUp(details.localPosition, context);
      },
    );
  }
}