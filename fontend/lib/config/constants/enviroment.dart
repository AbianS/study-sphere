import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String api_url =
      dotenv.env["API_URL"] ?? "http://192.168.216.163:3000";
}
