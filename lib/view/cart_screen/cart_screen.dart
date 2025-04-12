import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        title: cartScreenController.cartItems[index]
                                [AppConfig.itemTitle]
                            .toString(),
                        desc: cartScreenController.cartItems[index]
                                [AppConfig.itemPrice]
                            .toString(),
                        qty: cartScreenController.cartItems[index]
                                [AppConfig.itemQty]
                            .toString(),
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
                    itemCount: cartScreenController.cartItems.length,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Razorpay razorpay = Razorpay();
                    var options = {
                      'key': 'rzp_test_1DP5mmOlF5G5ag',
                      // kDebugMode
                      //     ? 'rzp_test_1DP5mmOlF5G5ag'
                      //     : "rzp_live_h33xU21Pn6h51e",
                      'amount': cartScreenController.totalAmount * 100,
                      'name': 'Acme Corp.',
                      'description': 'Fine T-Shirt',
                      'retry': {'enabled': false, 'max_count': 1},
                      'send_sms_hash': true,
                      'prefill': {
                        'contact': '8888888888',
                        'email': 'test@razorpay.com'
                      },
                      'external': {
                        'wallets': ['paytm']
                      }
                    };
                    razorpay.on(
                      Razorpay.EVENT_PAYMENT_ERROR,
                      handlePaymentErrorResponse,
                    );
                    razorpay.on(
                      Razorpay.EVENT_PAYMENT_SUCCESS,
                      handlePaymentSuccessResponse,
                    );
                    razorpay.on(
                      Razorpay.EVENT_EXTERNAL_WALLET,
                      handleExternalWalletSelected,
                    );
                    razorpay.open(options);
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Total Amount",
                            ),
                            Text("${cartScreenController.totalAmount} rs")
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          weight: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    // PaymentFailureResponse contains three values:
    // 1. Error Code
    // 2. Error Description
    // 3. Metadata
    showAlertDialog(
      context,
      'Payment Failed',
      'Code: ${response.code}\n'
          'Description: ${response.message}\n'
          'Metadata: ${response.error.toString()}',
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    // PaymentSuccessResponse contains three values:
    // 1. Order ID
    // 2. Payment ID
    // 3. Signature
    showAlertDialog(
      context,
      'Payment Successful',
      'Payment ID: ${response.paymentId}\n'
          'Order ID: ${response.orderId}\n'
          'Signature: ${response.signature}',
    );

    context.read<CartScreenController>().deleteAll();
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
      context,
      'External Wallet Selected',
      '${response.walletName}',
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}
