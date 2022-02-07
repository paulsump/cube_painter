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

  //
  // @override
  // bool operator ==(Object other) =>
  //     other is SimpleCube ? center == other.center && crop == other.crop : false;
  //
  // @override
  // int get hashCode => hashValues(center, crop);
  //
  // @override
  // String toString() => '$center,$crop';

  SimpleCube.fromJson(Map<String, dynamic> json, {Key? key})
      : center = json['center'],
        crop = Crop.values[json['cropIndex']],
        super(key: key);

  Map<String, dynamic> toJson() => {'center': center, 'cropIndex': crop.index};
}
