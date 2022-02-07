import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/shared/grid_transform.dart';
import 'package:cube_painter/widgets/unit_cube.dart';
import 'package:flutter/material.dart';

class SimpleCube extends StatelessWidget {
  final GridPoint center;

  final Crop crop;

  const SimpleCube(this.center, this.crop, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Offset offset = gridToUnit(center);

    return Transform.translate(
      offset: offset,
      child: crop == Crop.c
          //TODO SimpleCube - opacity means not using const UnitCube
          ? const UnitCube()
          : CroppedUnitCube(crop: crop),
    );
  }

  SimpleCube.fromJson(Map<String, dynamic> json, {Key? key})
      : center = json['center'],
        crop = json['crop'],
        super(key: key);

  Map<String, dynamic> toJson() => {'center': center, 'crop': crop};
}
