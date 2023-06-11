import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterduplo/flutterduplo.dart';

import 'themeclass.dart';

// Define your backend URL and Duplo public key.
String backendUrl = '{YOUR_BACKEND_URL}';
String DuploPublicKey = '{YOUR_duplo_PUBLIC_KEY}';
const String appName = 'Buplo Example';

void main() {
  runApp(const MyApp());
}

// MyApp is the main application widget.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();

  // Function to get the state of the MyApp widget from any context.
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  // Default theme mode is system.
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      home: const Newpage(),
    );
  }

  // Function to change the theme mode.
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

// Check if the app is running in dark mode.
bool get isDarkMode {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  return brightness == Brightness.dark;
}

// Newpage is the main interface of the app.
class Newpage extends StatefulWidget {
  const Newpage({Key? key}) : super(key: key);
  @override
  _NewpageState createState() => _NewpageState();
}

class _NewpageState extends State<Newpage> {
  var currency = ["USD", "NGN"]; // Supported currencies.
  String dropdownvalue = 'NGN'; // Default currency.
  TextEditingController phoneController = TextEditingController(); // Controller for the amount text field.
  bool isloading = false; // Loading state for the checkout button.
  final plugin = Duplo(); // Instance of the Duplo plugin.
  final _formKey = GlobalKey<FormState>(); // Form key for validating the form.
  bool check = false; // Check state for the dark mode checkbox.

  @override
  void initState() {
    check = isDarkMode;
    plugin.initialize(
         //test
        // publicKey: 'pk_test_z3q5jhyivn4png4zo7p2obnjdgbhmzygfib8ua',
        // secretKey: 'sk_test_eslf6wsrzvccc6xnp9pvukiejq8lauenhv7cp9w'
        publicKey: 'pk_live_cllwoquh6duwcojl6ils7mhoieene068gc3dgv',
        secretKey: 'sk_live_bfege07nepjhbrjebuth041im4pplrwv6bnvlbh'
    ); //Replace with your keys
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("DUPLO SDK SAMPLE"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                  value: check,
                  onChanged: (bool? value) {
                    setState(() {
                      check = !check;
                    });
                    if (!check) {
                      MyApp.of(context).changeTheme(ThemeMode.light);
                    } else {
                      MyApp.of(context).changeTheme(ThemeMode.dark);
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              DropdownButton(
                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: currency.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color(0xffF4F4F6),
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: const Color(0xffF4F4F6),
                    hintText: "1000",
                    hintStyle: TextStyle(
                        fontSize: 16.56,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? null : Colors.black),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Color(0xffF4F4F6)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Color(0xffF4F4F6)),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Color(0xffF4F4F6)),
                    ),
                  ),
                  style: TextStyle(
                      fontSize: 16.56,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? null : Colors.black),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    // widget.email(value);
                    if (value.isEmpty) {
                      setState(() {
                        // widget.emailfield(true);
                      });
                    } else {
                      setState(() {});
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "This field can't be empty";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.black),
                  height: 65,
                  width: MediaQuery.of(context).size.width - 70,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  alignment: Alignment.center,
                  child: isloading
                      ? loadingWidget
                      : const Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _handleCheckout(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleCheckout(BuildContext context) async {
    setState(() => isloading = true);
    _formKey.currentState?.save();
    Charge charge = Charge()
      ..amount = int.parse(phoneController.text) // In base currency
      ..email = 'sdkapp@email.com'
      ..currency = dropdownvalue;
    // ..card = _getCardFromUI();

    charge.reference = _getReference();

    try {
      var response = await plugin.checkout(
        context,
        charge: charge,
      );
      log('Response = $response');
      setState(() => isloading = false);
      _updateStatus(response.reference, '$response');
    } catch (e) {
      setState(() => isloading = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (!kIsWeb) {
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }
    } else {
      platform = "WEB";
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  _updateStatus(String? reference, String message) {
    _showMessage('Reference: $reference \n Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }
}

const loadingWidget = SpinKitThreeBounce(
  color: Colors.white,
  size: 30.0,
);

