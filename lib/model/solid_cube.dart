import 'package:cube_painter/model/grid_point.dart';
import 'package:cube_painter/shared/enums.dart';

class SolidCube {
  final GridPoint center;

  final Crop crop;

  SolidCube.fromJson(Map<String, dynamic> json)
      : center = json['center'],
        crop = json['crop'];

  Map<String, dynamic> toJson() => {'center': center, 'crop': crop};
}
