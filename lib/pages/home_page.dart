import 'package:flutter/material.dart';

import '../services/stripe_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Stripe Payment Demo",
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                StripeService.instance.makePayment();
              },
              color: Colors.green,
              child: const Text(
                "Purchase",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
