import 'dart:convert';

import 'package:cube_painter/data/assets.dart';
import 'package:flutter/material.dart';

/// various help text,
/// loaded from json
class Tip {
  final String id;

  final String text;

  const Tip({required this.id, required this.text});

  Tip.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'];

  Map<String, dynamic> toJson() => {'id': id, 'text': text};
}

/// list of tips loaded from a json file.
class Tips {
  final List<Tip> list;

  const Tips(this.list);

  Tips.fromJson(Map<String, dynamic> json)
      : list = _listFromJson(json).toList();

  @override
  String toString() => '$list';

  static Iterable<Tip> _listFromJson(Map<String, dynamic> json) sync* {
    for (final cubeInfoObject in json['list']) {
      yield Tip.fromJson(cubeInfoObject);
    }
  }

  Map<String, dynamic> toJson() => {'list': list};
}

/// access to the main store of the entire model
class TipNotifier extends ChangeNotifier {
  late Tips _tips;

  // String _currentTipId = '';

  // String get text=>_tips[_currentTipId];

  void load() async {
    const filePath = 'tips/buttons.json';

    final map = await Assets.loadJson(filePath);
    _tips = Tips.fromJson(map);
  }

  String get json => jsonEncode(_tips);
}
