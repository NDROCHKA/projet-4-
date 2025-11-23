import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use localhost for Web/iOS and 10.0.2.2 for Android
  // For web, we can just use localhost
  static const String baseUrl = 'http://localhost:3500';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String firstname, String lastname, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
  Future<List<dynamic>> getVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/video/getvideos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print('Get Videos error: $e');
      return [];
    }
  }
}
