import 'package:shopping_app/api/api_provider.dart';
import 'package:shopping_app/models/external_model/customer.dart';
import 'package:shopping_app/models/external_model/order.dart';
import 'package:shopping_app/models/external_model/products.dart';

class APIRepository {
  APIRepository._privateConstructor();
  static final APIRepository repository = APIRepository._privateConstructor();

  APIProvider _provider = APIProvider();

  Future<List<Products>> get getDataProductsFromApi => _provider.getDataProductsFromApiAsync();

  Future<String> get getPriceFromApi => _provider.getPriceFromApiAsync();

  Future<String> get getSkuIdFromApi => _provider.getSkuIdFromApiAsync();

  Future<String> createCustomerAndGetId(Customer customer) => _provider.createCustomerAndGetIdAsync(customer);

  Future<String> createOrderAndGetId(Order order) => _provider.createOrderAndGetIdAsync(order);
}