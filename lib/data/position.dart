import 'dart:ui';

/// Grid position x,y
/// indices on the triangle grid.
/// A coordinate space where x is across and
/// y is up and to the right by H and W respectively.
class Position {
  final int x, y;

  static const zero = Position(0, 0);

  const Position(this.x, this.y);

  operator +(Position other) => Position(x + other.x, y + other.y);

  operator -(Position other) => Position(x - other.x, y - other.y);

  operator *(int scale) => Position(x * scale, y * scale);

  operator /(int scale) => Position(x ~/ scale, y ~/ scale);

  @override
  bool operator ==(Object other) =>
      other is Position ? x == other.x && y == other.y : false;

  @override
  int get hashCode => hashValues(x, y);

  @override
  String toString() => '$x,$y';

  Position.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
