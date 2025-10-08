import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static Future<bool> sendProfileData(
    String name,
    String email,
    String age,
    String idToken,
  ) async {
    final url = 'http://192.168.29.191:8000/api/profile';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'name': name, 'email': email, 'age': age}),
    );

    return response.statusCode == 200;
  }
}

// lib/services/auth_service.dart

class AuthService {
  static Future<String?> getIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? await user.getIdToken() : null;
  }
}
