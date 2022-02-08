import 'package:cube_painter/out.dart';
import 'package:cube_painter/widgets/scafolding/grid.dart';
import 'package:cube_painter/widgets/scafolding/transformed.dart';
import 'package:flutter/material.dart';

const noWarn = out;

class ConstantPage extends StatelessWidget {

  const ConstantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transformed(
      child: Stack(
        children: const [
          Grid(),
        ],
      ),
    );
  }
}
