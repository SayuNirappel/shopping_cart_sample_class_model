import 'package:shopping_cart_may/config/app_config.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<String?> getData({required String endpoint}) async {
    final url = Uri.parse(AppConfig.baseUrl + endpoint);

    try {
      final responsse = await http.get(url);

      if (responsse.statusCode == 200) {
        print('Response data: ${responsse.body}');
        return responsse.body;
      } else {
        print('Error: ${responsse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
