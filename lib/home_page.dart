import 'package:cube_painter/out.dart';
import 'package:cube_painter/widgets/brush/painter_page.dart';
import 'package:cube_painter/widgets/scafolding/grid.dart';
import 'package:cube_painter/widgets/scafolding/transformed.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: const [
      Transformed(child: Grid()),
      PainterPage(),
    ]);
  }
}
