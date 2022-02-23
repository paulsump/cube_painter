//
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
//
// class Alert extends StatelessWidget {
//
//   String title;
//   String content;
//   VoidCallback continueCallBack;
//
//   Alert(this.title, this.content, this.continueCallBack, ) ;
//   TextStyle textStyle = const TextStyle (color: Colors.black);
//
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//         child:  AlertDialog(
//           title: Text(title,style: textStyle,),
//           content: Text(content, style: textStyle,),
//           actions: <Widget>[
//             FlatButton(
//               child: const Text("Continue"),
//               onPressed: () {
//                 continueCallBack();
//               },
//             ),
//             FlatButton(
//               child: const Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ));
//   }
// }
