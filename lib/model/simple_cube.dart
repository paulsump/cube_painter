import 'package:cube_painter/model/crop_direction.dart';
import 'package:cube_painter/model/grid_point.dart';
import 'package:flutter/material.dart';

class SimpleCube extends StatelessWidget {
  final GridPoint center;

  final Crop crop;

  const SimpleCube(this.center, this.crop, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  SimpleCube.fromJson(Map<String, dynamic> json, {Key? key})
      : center = json['center'],
        crop = json['crop'],
        super(key: key);

  Map<String, dynamic> toJson() => {'center': center, 'crop': crop};
}
