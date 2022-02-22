import 'package:flutter/material.dart';

class SavedThumbnail extends StatelessWidget {
  final String fileName;

  const SavedThumbnail({
    Key? key,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage('images/$fileName'));
  }
}
