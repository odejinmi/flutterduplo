import 'package:flutter/material.dart';

class NewAppbar extends AppBar {
  NewAppbar(
    context, {super.key, 
    name = "",
    bgcolor = Colors.white,
    iconcolor = Colors.black,
  }) : super(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: bgcolor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: iconcolor,
              )),
          title: Text(
            name,
            style: TextStyle(
                color: iconcolor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
}
