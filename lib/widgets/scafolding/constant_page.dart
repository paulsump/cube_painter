import 'package:cube_painter/widgets/cubes/simple_cube.dart';
import 'package:cube_painter/widgets/scafolding/grid.dart';
import 'package:cube_painter/widgets/scafolding/transformed.dart';
import 'package:flutter/material.dart';

class ConstantPage extends StatelessWidget {
  final List<SimpleCube> simpleCubes;

  const ConstantPage({Key? key, required this.simpleCubes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transformed(
          child: Stack(
            children: [
              const Grid(),
              ...simpleCubes,
            ],
          ),
        ),
      ],
    );
    ;
  }
}
