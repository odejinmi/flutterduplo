import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterduplo/src/constant/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseTextField extends StatelessWidget {
  final Widget? suffix;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final String? initialValue;

  const BaseTextField({
    Key? key,
    this.suffix,
    this.hintText,
    this.inputFormatters,
    this.onSaved,
    this.validator,
    this.controller,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Color(0xffF4F4F6),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters,
        onSaved: onSaved,
        validator: validator,
        maxLines: 1,
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xffF4F4F6)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xffF4F4F6)),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xffF4F4F6)),
          ),
          // border: const OutlineInputBorder(),
          suffixIcon: suffix == null
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12.0),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: FittedBox(child: suffix),
                  ),
                ),
          errorStyle: const TextStyle(fontSize: 12.0),
          errorMaxLines: 3,
          isDense: true,
          hintText: hintText,
          hintStyle: GoogleFonts.inconsolata(color: isDarkMode ? Colors.black : Colors.black,),
        ),
        style: GoogleFonts.inconsolata(color: isDarkMode ? Colors.black : Colors.black,),
      ),
    );
  }
}
