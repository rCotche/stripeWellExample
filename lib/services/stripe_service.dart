class StripeService {
  // private constructeur
  StripeService._();

  static final StripeService instance = StripeService._();
/*
* Cette partie doit être coté serveur, surtout le _createPaymentIntent
* la secret doit TOUJOURS être coté serveur
*/
  Future<void> makePayment() {
    try {} catch (e) {
      print(e);
    }
  }

  Future<void> _createPaymentIntent(int amount, String currency) {
    try {} catch (e) {
      print(e);
    }
  }
}
