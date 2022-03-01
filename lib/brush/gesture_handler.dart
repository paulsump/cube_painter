import 'package:flutter/material.dart';

abstract class GestureHandler {
  void start(Offset point, BuildContext context);

  void update(Offset point, BuildContext context);

  void end(BuildContext context);

  void tapUp(Offset point, BuildContext context);

  void tapDown(Offset point, BuildContext context);
}
