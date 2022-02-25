import 'package:cube_painter/out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const noWarn = out;

Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;

double getScreenWidth(BuildContext context) => getScreenSize(context).width;

double getScreenHeight(BuildContext context) => getScreenSize(context).height;

Offset getScreenCenter(BuildContext context) {
  final size = getScreenSize(context);
  return Offset(size.width, size.height) / 2;
}

