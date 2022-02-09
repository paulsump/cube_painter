import 'dart:ui';

/// x,y offset on the triangle grid -
/// a coordinate space where x is across and
/// y is up and to the right by H and W respectively.
class GridPoint {
  final int x, y;

  static const zero = GridPoint(0, 0);

  const GridPoint(this.x, this.y);

  operator +(GridPoint other) => GridPoint(x + other.x, y + other.y);

  operator -(GridPoint other) => GridPoint(x - other.x, y - other.y);

  operator *(int scale) => GridPoint(x * scale, y * scale);

  operator /(int scale) => GridPoint(x ~/ scale, y ~/ scale);

  // operator -() => GridPoint(-x, -y);

  @override
  bool operator ==(Object other) =>
      other is GridPoint ? x == other.x && y == other.y : false;

  @override
  int get hashCode => hashValues(x, y);

  @override
  String toString() => '$x,$y';

  GridPoint.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
