import '../constant/custom_alert_dialog.dart';
import 'method.dart';

Future<String> verifytransaction(data, key) async {
  var endpoint = "transaction/verify/$data";
  return await getApiCallTokenized(endpoint, key);
}

Future<String> depositcard(jsonBody, key) async {
  const endpoint = "cardsdk/initialize";
  return await postApiCallTokenized(jsonBody, endpoint, key);
}

Future<String> deposittransfer(jsonBody, key) async {
  const endpoint = "banktransfer/initialize";
  return await postApiCallTokenized(jsonBody, endpoint, key);
}

showCommonError(message, context) {
  Customalertdialogloader(context,
      title: "Whoops!!",
      message: message,
      negativeBtnText: 'Dismiss',
      onPostivePressed: () {},
      onNegativePressed: () {});
}

showCommonSuccess(message, context) {
  Customalertdialogloader(context,
      title: "Hurray!!!",
      message: message,
      negativeBtnText: 'Dismiss',
      onPostivePressed: () {},
      onNegativePressed: () {});
}

showCommonInfo(message, context) {
  Customalertdialogloader(context,
      title: "",
      message: message,
      negativeBtnText: 'Dismiss',
      onPostivePressed: () {},
      onNegativePressed: () {});
}
