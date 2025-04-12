import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart_may/models/home_screen_models/categries_res_model.dart';
import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/apis/home_screen_service.dart';

class HomeScreenController with ChangeNotifier {
  bool isCategoriesLoading = false; // Loading state for categories
  bool isProductsLoading = false; // Loading state for products

  int selectedCaegoryIndex = 0; // Index of the selected category

  List<CategoriesResModel> categoriesList = []; // List to store categories
  List<Product> productsList = []; // List to store products
  // fetch all categories from the API
  Future<void> fetchCategories() async {
    isCategoriesLoading = true;
    notifyListeners();

    try {
      final res = await HomeScreenService().fetchCategories();
      if (res != null) {
        // Assign the fetched categories to the list
        categoriesList = res;

        // to insert the "All" category at the beginning of the list
        categoriesList.insert(
            0, CategoriesResModel(slug: "all", name: "All", url: null));
        isCategoriesLoading = false;
        notifyListeners();
      } else {
        isCategoriesLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isCategoriesLoading = false;
      notifyListeners();
    }
  }

  onCategorySelection(int index) {
    selectedCaegoryIndex = index;
    log(selectedCaegoryIndex.toString());
    fetchProducts(); // Fetch products based on the selected category
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    isProductsLoading = true;
    notifyListeners();
    try {
      // Fetch products based on the selected category
      String categoySlug = categoriesList[selectedCaegoryIndex].slug.toString();

      final res =
          await HomeScreenService().fetchProducts(category: categoySlug);
      if (res != null) {
        ProductsResModel resModel = res;

// Check if the response is not null and assign the products to the list
        productsList = resModel.products ?? [];
      }
    } catch (e) {
      isProductsLoading = false;
      notifyListeners();
    }
    isProductsLoading = false;
    notifyListeners();
  }
}
