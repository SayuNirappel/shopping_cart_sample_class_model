import 'package:flutter/material.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/models/home_screen_models/products_res_model.dart';
import 'package:shopping_cart_may/repository/sqlflite_helper/sqlflite_helper.dart';

class CartScreenController with ChangeNotifier {
  List<Map> cartItems = [];
  double totalAmount = 0.00;

  Future<void> addData(Product product) async {
    await SqlfliteHelper.addToCart(
        title: product.title.toString(),
        price: product.price,
        productId: product.id);
    getData();
  }

  Future<void> getData() async {
    cartItems = await SqlfliteHelper.getAllData();
    calculateTotalAmount();
    notifyListeners();
  }

  Future<void> updateData({required int qty, required int id}) async {
    await SqlfliteHelper.updateData(qty: qty, id: id);
    getData();
  }

  void deleteData({required int id}) {
    SqlfliteHelper.deleteData(id: id);
    getData();
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    for (var item in cartItems) {
      double currentPrice = item[AppConfig.itemQty] * item[AppConfig.itemPrice];
      totalAmount = totalAmount + currentPrice;
    }
  }

  void deleteAll() {
    SqlfliteHelper.deleteAll();
    getData();
  }
}
