import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HyperPayService {
  // Replace with your actual credentials
  final String baseUrl = 'https://eu-test.oppwa.com/v1'; // Use 'https://eu-prod.oppwa.com/v1' for production
  final String entityId = '8a8294174d0595bb014d05d829cb01cd';
  final String authorizationBearer = 'Bearer OGE4Mjk0MTc0ZDA1OTViYjAxNGQwNWQ4MjllNzAxZDF8OVRuSlBjMm45aA==';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> createCheckout({
    required String amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkouts'),
        headers: {
          'Authorization': 'Bearer $authorizationBearer',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'entityId': entityId,
          'amount': amount,
          'currency': "SAR",
          'paymentType': "DB", // 'DB' for debit
          'integrity': 'true', // Required for PCI DSS v4.0 compliance
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Store the integrity value securely for later use
        if (responseData.containsKey('integrity')) {
          await secureStorage.write(
            key: 'hyperpay_integrity_${responseData['id']}',
            value: responseData['integrity'],
          );
        }
        return responseData;
      } else {
        throw Exception('Failed to create checkout: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating checkout: $e');
    }
  }

  Future<String?> getIntegrityValue(String checkoutId) async {
    return await secureStorage.read(key: 'hyperpay_integrity_$checkoutId');
  }

  // Generate a nonce for Content Security Policy
  String generateNonce() {
    return const Uuid().v4();
  }
}