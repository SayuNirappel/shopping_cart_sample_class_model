import 'package:flutter/foundation.dart';
import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/apis/product_detail_screen_service.dart';

class ProductDetailsScreenController with ChangeNotifier {
  bool isLoading = false;
  Product? productDetails;
  Future<void> fetchProductsdetails({required String productId}) async {
    isLoading = true;
    notifyListeners();
    try {
      final res = await ProductDetailScreenService()
          .fetchProductsdetails(id: productId);
      if (res != null) {
        productDetails = res;
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
    }
    isLoading = false;
    notifyListeners();
  }
}
