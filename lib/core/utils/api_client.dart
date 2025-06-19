import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/environment.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Uri _buildUri(String path) {
    return Uri.parse('${Environment.baseUrl}$path');
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
    String? token,
  }) {
    return _client.get(
      _buildUri(path),
      headers: _buildHeaders(headers, token),
    );
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    String? token,
  }) {
    return _client.post(
      _buildUri(path),
      headers: _buildHeaders(headers, token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
    String? token,
  }) {
    return _client.patch(
      _buildUri(path),
      headers: _buildHeaders(headers, token),
      body: jsonEncode(body),
    );
  }

  /// ✅ New PUT method
  Future<http.Response> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
    String? token,
  }) {
    return _client.put(
      _buildUri(path),
      headers: _buildHeaders(headers, token),
      body: jsonEncode(body),
    );
  }

  Map<String, String> _buildHeaders(
    Map<String, String>? customHeaders,
    String? token,
  ) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      ...?customHeaders,
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
