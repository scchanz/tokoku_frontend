import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.5.21:8000/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  static Future<bool> createProduct(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update.php?id=$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete.php?id=$id'));
    return response.statusCode == 200;
  }
}
