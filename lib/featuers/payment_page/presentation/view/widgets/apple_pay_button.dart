import 'package:flutter/material.dart';

class ApplePayButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ApplePayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height*0.05,
      width: MediaQuery.sizeOf(context).width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.black, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: Colors.black,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pay with ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro',
              ),
            ),
            Icon(
              Icons.apple,
              color: Colors.white,
              size: 20,
            ),
            Text(
              'Pay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}