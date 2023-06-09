import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../constant/submitbutton.dart';

class Walletfunded extends StatelessWidget {
  const Walletfunded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolour,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              "assets/images/checked.png",
              height: 117.5,
              width: 117.5,
            ),
            const SizedBox(
              height: 23,
            ),
            const Text(
              "Transaction Successfully",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Submitbutton(
                buttoncolor: Colors.white,
                textcolor: const Color(0xff6C30F4),
                name: "Done",
                press: () {}),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
