import 'package:flutter/material.dart';

/// TODO Responsive to screen size- magic numbers
const double _pageButtonHeight = 70;
const Size pageButtonSize = Size(_pageButtonHeight, _pageButtonHeight);

const double normalIconSize = 33;
const double downloadedIconSize = 27;

class DownloadedIcons {
  static const _kFontFam = 'DownloadedIcons';
  static const String? _kFontPkg = null;

  static const IconData plusOutline =
      IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cancelOutline =
      IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData docNew =
      IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData thumbsUp =
      IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData thumbsDown =
      IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData copy =
      IconData(0xf0c5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
