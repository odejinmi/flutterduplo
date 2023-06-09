// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Customalertdialog extends StatelessWidget {
  final Color? bgColor;
  final String title;
  final String message;
  final String? positiveBtnText;
  final String? negativeBtnText;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double? circularBorderRadius;

  const Customalertdialog({
    Key? key,
    required this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText,
    this.negativeBtnText,
    this.onPostivePressed,
    this.onNegativePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius!)),
      actions: <Widget>[
        Visibility(
          visible: negativeBtnText != null ? true : false,
          child: ElevatedButton(
            child: Text(negativeBtnText ?? ""),
            // textColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              Navigator.of(context).pop();
              if (onNegativePressed != null) {
                onNegativePressed!();
              }
            },
          ),
        ),
        Visibility(
          visible: positiveBtnText != null ? true : false,
          child: ElevatedButton(
            child: Text(positiveBtnText ?? ""),
            // textColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              if (onPostivePressed != null) {
                onPostivePressed!();
              }
            },
          ),
        )
      ],
    );
  }
}

Customalertdialogloader(BuildContext context,
    {required String title,
    required String message,
    bool disable = true,
    required String negativeBtnText,
    String? positiveBtnText,
    Function? onPostivePressed,
    required Function onNegativePressed}) {
  var dialog = Customalertdialog(
      title: title,
      message: message,
      onPostivePressed: onPostivePressed,
      positiveBtnText: positiveBtnText,
      onNegativePressed: onNegativePressed,
      negativeBtnText: negativeBtnText);
  showDialog(
      context: context,
      barrierDismissible: disable,
      builder: (BuildContext context) => dialog);
}
