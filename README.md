#  A Duplo Plugin for Flutter Apps

Flutter plugin for making payments with Duplo Payment System. Fully
supports all platform.


## Features
Current
- Card
- Bank



## Installation
To use this plugin, add `flutterduplo` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

Then initialize the plugin preferably in the `initState` of your widget.

``` dart
import 'package:flutterduplo/flutterduplo.dart';

class _ExamplePayementPageState extends State<ExamplePayementPage> {
  var publicKey = 'Add your Duplo Public Key Here';
  var secretKey = 'Add your Duplo Secret Key Here';
  final plugin = Duplo();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey,secretKey:secretKey);
  }
}
```

## Making Payments
There are two ways of making payment with the plugin.
1.  **Checkout**: This is the easy way; as the plugin handles all the
    processes involved in making a payment (except transaction
    initialization and verification which should be done from your
    backend).
2.  **Charge Card**: This is a longer approach; you handle all callbacks
    and UI states.

### 1. Checkout (Recommended)
You initialize a charge object with an amount, email & accessCode or
reference.


 ```dart
 Charge charge = Charge()
       ..amount = 10000
       ..reference = _getReference()
        // or ..accessCode = _getAccessCodeFrmInitialization()
       ..email = 'customer@email.com';
     CheckoutResponse response = await plugin.checkout(
       context context,
       method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
       charge: charge,
     );
 ```

`plugin.checkout()` returns the state and details of the
payment in an instance of `CheckoutResponse` .



### 2. Charge Card
You can choose to initialize the payment locally or via your backend.

Just send the payment details to  `plugin.chargeCard`
```dart
      // Set transaction params directly in app (note that these params
      // are only used if an access_code is not set. In debug mode,
      // setting them after setting an access code would throw an error
      Charge charge = Charge();
      charge.card = _getCardFromUI();
      charge
        ..amount = 2000
        ..email = 'user@email.com'
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Flutter PLUGIN');
      _chargeCard();
```


## Validating Card Details
You are expected but not required to build the UI for your users to enter their payment details.
For easier validation, wrap the **TextFormField**s inside a **Form** widget. Please check this article on
[validating forms on Flutter](https://medium.freecodecamp.org/how-to-validate-forms-and-user-input-the-easy-way-using-flutter-e301a1531165)
if this is new to you.

**NOTE:** You don't have to pass a card object to ``Charge``. The plugin will call-up a UI for the user to input their card.

You can validate the fields with these methods:
#### card.validNumber
This method helps to perform a check if the card number is valid.

#### card.validCVC
Method that checks if the card security code is valid.

#### card.validExpiryDate
Method checks if the expiry date (combination of year and month) is valid.

#### card.isValid
Method to check if the card is valid. Always do this check, before charging the card.


#### card.getType
This method returns an estimate of the string representation of the card type(issuer).


## Running Example project
For help getting started with Flutter, view the online [documentation](https://flutter.dev).

An [example project]( https://github.com/odejinmi/flutterduplo) has been provided in this plugin.
Clone this repo and navigate to the **example** folder. Open it with a supported IDE or execute `flutter run` from that folder in terminal.

## Contributing, Issues and Bug Reports
The project is open to public contribution. Please feel very free to contribute.
Experienced an issue or want to report a bug? Please, [report it here]( https://github.com/odejinmi/flutterduplo/issues). Remember to be as descriptive as possible.