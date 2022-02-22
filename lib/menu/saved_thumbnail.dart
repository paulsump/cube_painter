import 'package:flutter/material.dart';

class ImageThumb extends StatelessWidget {
  final String filePath;

  const ImageThumb({
    Key? key,
    required this.filePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage('$filePath'));
  }

//TODO onTap, load
// final cubeGroupNotifier = getCubeGroupNotifier(context);
// if (cubeGroupNotifier.currentName == 'triangle')

}
