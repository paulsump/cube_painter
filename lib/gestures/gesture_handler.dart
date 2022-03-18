// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';

/// This interface allows [Gesturer] to
/// use [PanZoomer] when pinching
/// and [Brusher] otherwise.
abstract class GestureHandler {
  void start(Offset point, BuildContext context);

  void update(Offset point, double scale, BuildContext context);

  void end(BuildContext context);

  void tapUp(Offset point, BuildContext context);

  void tapDown(Offset point, BuildContext context);
}
