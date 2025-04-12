import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/controllers/cart_screen_controller.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<CartScreenController>().getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartScreenController = context.watch<CartScreenController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    title: cartScreenController.cartItems[index]
                        [AppConfig.itemTitle],
                    desc: cartScreenController.cartItems[index]
                        [AppConfig.itemPrice],
                    qty: cartScreenController.cartItems[index]
                        [AppConfig.itemQty],
                    image:
                        "https://images.pexels.com/photos/28518049/pexels-photo-28518049/free-photo-of-winter-wonderland-by-a-frozen-river.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                    onIncrement: () {
                      int qty = cartScreenController.cartItems[index]
                          [AppConfig.itemQty];
                      int id = cartScreenController.cartItems[index]
                          [AppConfig.primaryKey];

                      qty++;
                      context
                          .read<CartScreenController>()
                          .updateData(qty: qty, id: id);
                    },
                    onDecrement: () {
                      int qty = cartScreenController.cartItems[index]
                          [AppConfig.itemQty];
                      int id = cartScreenController.cartItems[index]
                          [AppConfig.primaryKey];

                      if (qty >= 2) {
                        qty--;
                        context
                            .read<CartScreenController>()
                            .updateData(qty: qty, id: id);
                      }
                    },
                    onRemove: () {
                      context.read<CartScreenController>().deleteData(
                            id: cartScreenController.cartItems[index]
                                [AppConfig.primaryKey],
                          );
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: 2)),
      ),
    );
  }
}
