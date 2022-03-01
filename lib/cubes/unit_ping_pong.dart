import 'dart:math';
import 'dart:ui';

double pingPongBetween(double start, double end, unitValue) =>
    lerpDouble(start, end, unitPingPong(unitValue))!;

double unitPingPong(double unitValue) => (1 + sin(2 * pi * unitValue)) / 2;

double lerp(double start, double end, unitValue) =>
    lerpDouble(start, end, unitValue)!;
