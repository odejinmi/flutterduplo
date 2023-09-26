// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../constant/submitbutton.dart';
import 'base_widget.dart';
import 'input/pin_field.dart';

class PinWidget extends StatefulWidget {
  final Function onpress;
  const PinWidget({Key? key, required this.onpress}) : super(key: key);

  @override
  _PinWidgetState createState() => _PinWidgetState();
}

class _PinWidgetState extends BaseState<PinWidget> {
  var heightBox = const SizedBox(height: 20.0);
  String pined = "";

  @override
  void initState() {
    confirmationMessage = 'Do you want to cancel PIN input?';
    super.initState();
  }

  @override
  Widget buildChild(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              heightBox,
              heightBox,
              const Text("Enter Card PIN", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),),
              const Text("Provide the 4-digit pin of your card", style: TextStyle(fontSize: 14.65, fontWeight: FontWeight.w400),),
              heightBox,
              heightBox,
              PinField(onSaved: (String pin) {
                setState(() {
                  pined = pin;
                });
              }),
              heightBox,
              Submitbutton(
                  name: "Proceed",
                  buttoncolor: disablebutton ?const Color(0x4069ceb8):const Color(0xff69ceb8),
                  press: () async {
                    if (disablebutton) return;
                    widget.onpress(pined);
                    // Navigator.of(context).pop(pined);
                  }),
            ],
          ),
        ),
      );
  }

  get disablebutton => pined.length != 4;
}
