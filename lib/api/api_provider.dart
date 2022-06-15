import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shopping_app/models/external_model/customer.dart';
import 'package:shopping_app/models/external_model/order.dart';
import 'package:shopping_app/models/external_model/products.dart';
import 'package:shopping_app/api/payment_services/stripr_services.dart';
import 'package:http/http.dart' as http;

class APIProvider {
  static String baseUrl = 'https://api.stripe.com/v1';
  static String accessToken = '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';
  Dio dio = Dio();

  _myHeaders(){
    return {
      "Authorization" : "Bearer $accessToken"
    };
  }

  Future<List<Products>> getDataProductsFromApiAsync() async {
    Response response = await dio.get('$baseUrl/products' , 
                                      options: Options(headers: _myHeaders())
                                      );
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['data']));
      List listProducts = rawData.map((f) => Products.fromJson(f)).toList();
      return listProducts;
    }
    throw DioErrorType;
  }

  Future<String> getSkuIdFromApiAsync() async {
    Response response = await dio.get('$baseUrl/skus' , 
                                      options: Options(headers: _myHeaders())
                                      );
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['data']));
      if(rawData != null)
        return '${rawData[0]['id']}';
    }
    throw DioErrorType;
  }

  Future<String> getPriceFromApiAsync() async {
    Response response = await dio.get('$baseUrl/prices?limit=1' , 
                                      options: Options(headers: _myHeaders())
                                      );
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['data']));
      if(rawData != null)
        return '${rawData[0]['unit_amount']}';
    }
    throw DioErrorType;
  }

  Future<String> createCustomerAndGetIdAsync(Customer customer) async {
      Map<String, dynamic> body = {
        'name': customer.name,
        'email': customer.email,
        'shipping[phone]' : customer.shipping.phone,
        'shipping[name]' : customer.shipping.name,
        'shipping[address][line1]' : customer.shipping.address.line1,
        'shipping[address][city]' : customer.shipping.address.city,
        'shipping[address][state]' : customer.shipping.address.state,
        'shipping[address][country]' : customer.shipping.address.country,
        'shipping[address][postal_code]' : customer.shipping.address.postalCode,
      };
  
    var response = await http.post(
        '$baseUrl/customers',
        body: body,
        headers: StripeService.headers
      );
    if(response.statusCode == 200){
      final Map<String , dynamic> rawData = jsonDecode(response.body);
      return rawData['id'];
    }
    throw DioErrorType;
  }

  Future<String> createOrderAndGetIdAsync(Order order) async {
    Map<String, dynamic> body = {
        'currency': 'usd',
        'email': order.email,
        'items[0][type]' : 'sku',
        'items[0][parent]' : order.items[0].parent ,
        'shipping[name]' : order.shipping.name,
        'shipping[phone]' : order.shipping.phone,
        'shipping[address][line1]' : order.shipping.address.line1,
        'shipping[address][city]' : order.shipping.address.city,
        'shipping[address][state]' : order.shipping.address.state,
        'shipping[address][country]' : order.shipping.address.country,
        'shipping[address][postal_code]' : order.shipping.address.postalCode,
        'customer' : order.customer ,
        // 'metadata[size]' : order.metadata.size ,
        'metadata[gender]' : order.metadata.gender,
        'metadata[age]' : order.metadata.age ,
        'metadata[note]' : order.metadata.note ,
      };
    var response = await http.post(
        '$baseUrl/orders',
        body: body,
        headers: StripeService.headers
      );
    if(response.statusCode == 200){
      final Map<String , dynamic> rawData = jsonDecode(response.body);
      return rawData['id'];
    }
    throw DioErrorType;
  }
}