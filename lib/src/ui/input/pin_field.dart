import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 10),
      // child: TextField(
      //   keyboardType: TextInputType.number,
      //   textAlign: TextAlign.center,
      //   style: const TextStyle(
      //     fontWeight: FontWeight.bold,
      //     color: Colors.grey,
      //     fontSize: 25.0,
      //     letterSpacing: 15.0,
      //   ),
      //   autofocus: true,
      //   inputFormatters: [
      //     FilteringTextInputFormatter.digitsOnly,
      //     LengthLimitingTextInputFormatter(widget.pinLength),
      //   ],
      //   obscureText: true,
      //   decoration: InputDecoration(
      //     border: const OutlineInputBorder(),
      //     isDense: true,
      //     hintText: 'ENTER PIN',
      //     hintStyle: const TextStyle(
      //       color: Colors.grey,
      //       fontSize: 14.0,
      //       letterSpacing: 0,
      //     ),
      //     contentPadding: const EdgeInsets.all(10.0),
      //     enabledBorder: const OutlineInputBorder(
      //         borderSide: BorderSide(color: Colors.grey, width: 0.5)),
      //     focusedBorder: OutlineInputBorder(
      //         borderSide: BorderSide(
      //             color: Theme.of(context).colorScheme.secondary, width: 1.0)),
      //   ),
      //   onChanged: (String value) {
      //     if (value.length == widget.pinLength) {
      //       widget.onSaved!(value);
      //     }
      //   },
      // ),
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: TextStyle(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
        length: widget.pinLength,
        obscureText: false,
        obscuringCharacter: '*',
        animationType: AnimationType.fade,
        validator: (v) {
          // if (v!.length < 3) {
          //   return "I'm from validator";
          // } else {
          //   return null;
          // }
        },
        pinTheme: PinTheme(
          inactiveFillColor: Color(0xffF7F9FD),
          inactiveColor: Color(0xffE6EBF3),
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 60,
          fieldWidth: 50,
          borderWidth: 2,
          activeFillColor: Color(0xffE4F8F4),
          activeColor: Color(0xffA8DBD1),
          selectedFillColor: Color(0xffF7F9FD),
          selectedColor: Color(0xffE6EBF3),
          // hasError ? Colors.orange : Colors.white,
        ),
        cursorColor: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        textStyle: TextStyle(fontSize: 20, height: 1.6),
        enableActiveFill: true,
        errorAnimationController: errorController,
        controller: textEditingController,
        keyboardType: TextInputType.number,
        boxShadows: [
          BoxShadow(
            offset: Offset(0, 1),
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
        onCompleted: (v) {
          print("Completed");
        },
        // onTap: () {
        //   print("Pressed");
        // },
        onChanged: (value) {
          print(value);
          widget.onSaved!(value);
          // setState(() {
          //   currentText = value;
          // });
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }
}
