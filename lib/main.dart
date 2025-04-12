import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controllers/cart_screen_controller.dart';
import 'package:shopping_cart_may/controllers/home_screen_controller.dart';
import 'package:shopping_cart_may/controllers/product_details_screen_controller.dart';
import 'package:shopping_cart_may/repository/sqlflite_helper/sqlflite_helper.dart';
import 'package:shopping_cart_may/view/get_started_screen/get_started_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqlfliteHelper.initDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductDetailsScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartScreenController(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GetStartedScreen(),
      ),
    );
  }
}
