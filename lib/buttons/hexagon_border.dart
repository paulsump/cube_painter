import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _borderSide = BorderSide(width: 1.0, color: buttonBorderColor);
final hexagonBorderShape =
    MaterialStateProperty.all(HexagonBorder(side: _borderSide));

/// A border that fits a Hexagon within the available space.
///
/// Typically used with [ShapeDecoration] to draw a Hexagon.
///
/// The [dimensions] assume that the border is being used in a square space.
/// When applied to a rectangular space, the border paints in the center of the
/// rectangle.
///
/// See also:
///
///  * [BorderSide], which is used to describe each side of the box.
///  * [Border], which, when used with [BoxDecoration], can also
///    describe a Hexagon.
class HexagonBorder extends OutlinedBorder {
  /// Create a Hexagon border.
  ///
  /// The [side] argument must not be null.
  const HexagonBorder({BorderSide side = BorderSide.none}) : super(side: side);

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(side.width);
  }

  @override
  ShapeBorder scale(double t) => HexagonBorder(side: side.scale(t));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is HexagonBorder) {
      return HexagonBorder(side: BorderSide.lerp(a.side, side, t));
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is HexagonBorder) {
      return HexagonBorder(side: BorderSide.lerp(side, b.side, t));
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // return Path()..addRect(rect);
    return calcHexagonPath(
      rect.center,
      (rect.shortestSide - side.width) / 2.0,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // return Path()..addRect(rect);
    return calcHexagonPath(
      rect.center,
      rect.shortestSide / 2.0,
    );
  }

  @override
  HexagonBorder copyWith({BorderSide? side}) {
    return HexagonBorder(side: side ?? this.side);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(getInnerPath(rect), side.toPaint());
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is HexagonBorder && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'HexagonBorder')}($side)';
  }
}
