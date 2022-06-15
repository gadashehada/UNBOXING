import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shopping_app/api/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/external_model/customer.dart';
import 'package:shopping_app/views/home.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String paymentApiUrl = '${APIProvider.baseUrl}/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${APIProvider.accessToken}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
        StripeOptions(
          publishableKey: "pk_live_NzA4cv47bDxLBoNf2jJs7bVP00wjge6lWM", 
          merchantId: "", 
          androidPayMode: 'test'),
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard(
    {CreditCard userCard ,BillingAddress billingAddress , String customerId , Shipping shipping ,String amount, String currency , String orderId , String email}) async {
    try {
      var paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          card: userCard,
          billingAddress: billingAddress,
        ),
      );

      var paymentIntent = await StripeService.createPaymentIntent(
        amount,
        currency ,
        customerId,
        shipping ,
        orderId,
        email
      );

      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id
        )
      );

      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false
        );
      }
    } on PlatformException catch(err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${err.toString()}',
        success: false
      );
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(
      message: message,
      success: false
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
    String amount, String currency , String customerId , Shipping shipping , String orderId , String email) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card' ,
        'customer' : customerId,
        'shipping[name]' : shipping.name,
        'shipping[address][line1]' :  shipping.address.line1,
        'shipping[address][city]' : shipping.address.city,
        'shipping[address][state]' : shipping.address.state,
        'shipping[address][country]' : shipping.address.country,
        'shipping[address][postal_code]' : shipping.address.postalCode,
        'receipt_email': email,
        'description' : 'Oreder Id : $orderId , Product Name : ${Home.p.name}'
      };

      var response = await http.post(
        StripeService.paymentApiUrl,
        body: body,
        headers: StripeService.headers
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}