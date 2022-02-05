import 'package:cube_painter/shared/screen.dart';
import 'package:cube_painter/widgets/cube.dart';
import 'package:flutter/material.dart';

class PainterPage extends StatelessWidget {
  const PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(Screen.width / 2, Screen.height / 2),
      child: Transform.scale(
        scale: 33,
        child: const Cube(),
      ),
    );
  }
}
