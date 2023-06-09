import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Submitbutton extends StatelessWidget {
  final String name;
  final Function press;
  final bool isloading;
  final Color buttoncolor, textcolor;
  const Submitbutton(
      {Key? key,
      required this.name,
      this.isloading = false,
      required this.press,
      this.buttoncolor = const Color(0xff69CEB8),
      this.textcolor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: buttoncolor),
        height: 50,
        width: MediaQuery.of(context).size.width - 70,
        padding: const EdgeInsets.symmetric(vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        child: Text(
          name,
          style: GoogleFonts.dmSans(
            color: textcolor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        press();
      },
    );
  }
}
