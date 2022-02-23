import 'dart:ui';

import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback yesCallBack;

  const Question(
      {Key? key,
      required this.title,
      required this.content,
      required this.yesCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
        ),
        content: Text(
          content,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              yesCallBack();
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
