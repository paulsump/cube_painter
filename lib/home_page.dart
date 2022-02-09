import 'package:cube_painter/grid.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/painter_page.dart';
import 'package:cube_painter/transform/unit_to_screen.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: const [
      UnitToScreen(child: Grid()),
      PainterPage(),
    ]);
  }
}
