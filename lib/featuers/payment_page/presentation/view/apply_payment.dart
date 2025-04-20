import 'package:flutter/material.dart';
import '../../service/hyper_pay_service.dart';
import 'hyper_pay_web_view.dart';

class ApplePaymentView extends StatefulWidget {
  final String amount;

  const ApplePaymentView({
    Key? key,
    required this.amount,
  }) : super(key: key);

  @override
  State<ApplePaymentView> createState() => _ApplePaymentViewState();
}

class _ApplePaymentViewState extends State<ApplePaymentView> {
  final HyperPayService _hyperPayService = HyperPayService();
  bool _isLoading = false;

  Future<void> _initiatePayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Generate a nonce for CSP
      final String nonce = _hyperPayService.generateNonce();

      // Create checkout session
      final checkoutResult = await _hyperPayService.createCheckout(
        amount: widget.amount, // 'DB' for debit
      );

      final String checkoutId = checkoutResult['id'];

      // Get the integrity value for this checkout
      final String? integrityValue = await _hyperPayService.getIntegrityValue(checkoutId);

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      // Navigate to payment webview
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HyperPayWebViewScreen(
            checkoutId: checkoutId,
            integrityValue: integrityValue,
            nonce: nonce,
            onPaymentCompleted: (result) {
              _handlePaymentResult(result);
            },
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment initialization failed: ${e.toString()}')),
      );
    }
  }

  void _handlePaymentResult(Map<String, dynamic> result) {
    if (!mounted) return;

    Navigator.of(context).pop(); // Close the payment screen

    if (result['status'] == 'success') {
      _showResultDialog('Payment Successful', 'Your payment was processed successfully.');
    } else if (result['status'] == 'failure') {
      _showResultDialog('Payment Failed', 'There was an issue processing your payment. Please try again.');
    } else {
      _showResultDialog('Payment Cancelled', 'The payment process was cancelled.');
    }
  }

  Future<void> _showResultDialog(String title, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total: ${widget.amount} SAR',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _initiatePayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}