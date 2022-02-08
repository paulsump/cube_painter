import 'package:cube_painter/model/cube_group.dart';
import 'package:cube_painter/model/cube_info.dart';
import 'package:cube_painter/model/cube_store.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/widgets/brush/painter_page.dart';
import 'package:cube_painter/widgets/cubes/simple_cube.dart';
import 'package:cube_painter/widgets/scafolding/constant_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const noWarn = out;

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ConstantPage(
        simpleCubes: _createCubesFromGroup(context),
      ),
      const PainterPage(),
    ]);
  }
}

List<SimpleCube> _createCubesFromGroup(BuildContext context) {
  final cubeStore = Provider.of<CubeStore>(context, listen: true);
  CubeGroup cubeGroup = cubeStore.getCurrentCubeGroup();
  final cubes = <SimpleCube>[];
  for (CubeInfo cubeInfo in cubeGroup.list) {
    cubes.add(SimpleCube(
      info: cubeInfo,
    ));
  }
  return cubes;
}
