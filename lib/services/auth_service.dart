import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    String id = '',
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/getloginAPP',
    ).replace(
      queryParameters: {
        'sap-client': ApiConfig.sapClient,
        'user': username,
        'password': password,
        'id': id,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('HTTP Error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    if (data is! List || data.isEmpty) {
      throw Exception('Invalid SAP response');
    }

    return Map<String, dynamic>.from(data[0]);
  }
}