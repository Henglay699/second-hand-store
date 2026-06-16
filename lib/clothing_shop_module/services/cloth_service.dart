import 'package:clothing_shop/clothing_shop_module/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ClothService {
  Future<List<ProductModel>> getCloths() async {
    try {
      final url = 'https://fakestoreapi.com/products';
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<ProductModel> clothes = await compute(
          productModelFromJson,
          response.body,
        );
        return clothes;
      } else {
        throw Exception('Failed to load cloths');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
