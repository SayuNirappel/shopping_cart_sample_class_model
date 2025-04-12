import 'package:shopping_cart_may/models/home_screen_models/categries_res_model.dart';
import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/api_helper/api_helper.dart';

class HomeScreenService {
  Future<List<CategoriesResModel>?> fetchCategories() async {
    final resBody = await ApiHelper.getData(endpoint: "/products/categories");

    if (resBody != null) {
      final resModel = categoriesResModelFromJson(resBody);
      return resModel;
    } else {
      return null;
    }
  }

  Future<ProductsResModel?> fetchProducts({String? category}) async {
    String? url;
    if (category == "all") {
      url = "/products";
    } else {
      url = '/products/category/$category';
    }

    final resBody = await ApiHelper.getData(endpoint: url);

    if (resBody != null) {
      ProductsResModel resModel = productsResModelFromJson(resBody);

      return resModel;
    } else {
      return null;
    }
  }
}
