import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinField extends StatefulWidget {
  final ValueChanged<String>? onSaved;
  final int pinLength;

  const PinField({Key? key, this.onSaved, this.pinLength = 4})
      : super(key: key);

  @override
  State createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {

  TextEditingController textEditingController = TextEditingController();
  late StreamController<ErrorAnimationType> errorController;
  @override
  void initState() {
    // onTapRecognizer = TapGestureRecognizer()
    //   ..onTap = () {
    //     Navigator.pop(context);
    //   };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: widget.pinLength,
      obscureText: false,
      obscuringCharacter: '*',
      animationType: AnimationType.fade,
      // validator: (v) {
      //   // if (v!.length < 3) {
      //   //   return "I'm from validator";
      //   // } else {
      //   //   return null;
      //   // }
      // },
      pinTheme: PinTheme(
        inactiveFillColor: const Color(0xffF7F9FD),
        inactiveColor: const Color(0xffE6EBF3),
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 60,
        fieldWidth: 50,
        borderWidth: 2,
        activeFillColor: const Color(0xffE4F8F4),
        activeColor: const Color(0xffA8DBD1),
        selectedFillColor: const Color(0xffF7F9FD),
        selectedColor: const Color(0xffE6EBF3),
        // hasError ? Colors.orange : Colors.white,
      ),
      cursorColor: Colors.black,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: const TextStyle(fontSize: 20, height: 1.6),
      enableActiveFill: true,
      errorAnimationController: errorController,
      controller: textEditingController,
      keyboardType: TextInputType.number,
      boxShadows: const [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onCompleted: (v) {
        debugPrint("Completed");
      },
      // onTap: () {
      //   print("Pressed");
      // },
      onChanged: (value) {
        debugPrint(value);
        widget.onSaved!(value);
        // setState(() {
        //   currentText = value;
        // });
      },
      beforeTextPaste: (text) {
        debugPrint("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}
