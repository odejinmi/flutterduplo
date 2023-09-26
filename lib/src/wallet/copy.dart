

// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Copy extends StatefulWidget {
  String quote;
  Copy({Key? key, required this.quote,}) : super(key: key);

  @override
  _CopyState createState() => _CopyState();
}

class _CopyState extends State<Copy> {
  String name = "Copy";
  var icon = Icons.copy;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: widget.quote));
        setState(() {
          name = "Copied!";
          icon = Icons.check_circle;
          Future.delayed(const Duration(milliseconds: 3000), () {
            setState(() {
              name = "Copy";
              icon = Icons.copy;
            });
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: const BoxDecoration(
          color: Color(0xff69CEB8),
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 9.11,
              color: Colors.white,
            ),
            const SizedBox(width: 5,),
            Text(
              name,
              style: const TextStyle(fontSize: 7.59, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )
    );
  }
}
