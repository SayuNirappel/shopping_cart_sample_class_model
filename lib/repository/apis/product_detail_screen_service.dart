import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/api_helper/api_helper.dart';

class ProductDetailScreenService {
  Future<Product?> fetchProductsdetails({required String id}) async {
    final resBody = await ApiHelper.getData(endpoint: "/products/$id");

    if (resBody != null) {
      Product resModel = productFromjson(resBody);
      return resModel;
    } else {
      return null;
    }
  }
}
