import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<bool> register(
    String firstname, 
    String lastname, 
    String email, 
    String password,
    String profileImage,
    String description,
    String birthdate,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
          'profileImage': profileImage,
          'description': description,
          'birthdate': birthdate,
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

  Future<String?> getMyPageId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/page/mypage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['_id'];
      }
      return null;
    } catch (e) {
      print('Get My Page error: $e');
      return null;
    }
  }

  Future<bool> uploadVideo(
    String title,
    String description,
    XFile videoFile,
    XFile? thumbnailFile,
    String pageId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/video/uploadvideo'));
      request.headers['Authorization'] = 'Bearer $token';
      
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['pageId'] = pageId;

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'video', 
          await videoFile.readAsBytes(), 
          filename: videoFile.name,
          contentType: _getMediaType(videoFile.mimeType, 'video', 'mp4'),
        ));

        if (thumbnailFile != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'thumbnail', 
            await thumbnailFile.readAsBytes(), 
            filename: thumbnailFile.name,
            contentType: _getMediaType(thumbnailFile.mimeType, 'image', 'jpeg'),
          ));
        }
      } else {
        request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));

        if (thumbnailFile != null) {
          request.files.add(await http.MultipartFile.fromPath('thumbnail', thumbnailFile.path));
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Upload failed: ${response.body}');
        throw Exception('Upload failed: ${response.body}');
      }
    } catch (e) {
      print('Upload error: $e');
      rethrow;
    }
  }

  Future<bool> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/user/deleteOne'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        return true;
      }
      return false;
    } catch (e) {
      print('Delete Account error: $e');
      return false;
    }
  }

  MediaType _getMediaType(String? mimeType, String defaultType, String defaultSubType) {
    if (mimeType == null || mimeType.isEmpty) {
      return MediaType(defaultType, defaultSubType);
    }
    try {
      return MediaType.parse(mimeType);
    } catch (e) {
      print('Error parsing mime type "$mimeType": $e');
      return MediaType(defaultType, defaultSubType);
    }
  }
}
