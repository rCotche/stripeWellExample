import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_well_example/consts.dart';

class StripeService {
  // private constructeur
  StripeService._();

  static final StripeService instance = StripeService._();
/*
* Cette partie doit être coté serveur, surtout le _createPaymentIntent
* la secret doit TOUJOURS être coté serveur
*/

  //step 2 : client
  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(10, "usd");
      if (paymentIntentClientSecret == null) {
        return;
      }
      //create payment sheet

      //c'est ici qu'on pourra parametre apple pay et google pay
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: "tuto Hussein le goat"),
      );
      await _processPayment();
    } catch (e) {
      print(e);
    }
  }

  //step 1 : coté serveur
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();

      ///A positive integer representing how much to charge in the smallest currency unit
      ///(e.g., 100 cents to charge $1.00 or 100 to charge ¥100, a zero-decimal currency)
      ///pour 1€ ce sera 100 car on parle en centimes
      Map<String, dynamic> data = {
        "amount": _calculatedAmount(amount),
        "currency": currency,
      };
      //J'envoie vers où : c'est le path = "https://api.stripe.com/v1/payment_intents"
      //J'envoie quoi : c'est le data = data (ma map)
      //Je dois envoyer ma secret key, comment :
      //grâce à options
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-type": "application/x-www-form-urlencoded",
          },
        ),
      );
      if (response.data != null) {
        print(response.data);
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  //step 3
  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
    }
  }

  String _calculatedAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
