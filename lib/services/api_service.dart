import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://localhost:5000/api";

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/auth/login"), body: {
      "email": email,
      "password": password,
    });

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/auth/register"), body: {
      "email": email,
      "password": password,
    });

    return json.decode(response.body);
  }
}
