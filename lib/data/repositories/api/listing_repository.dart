import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/models/listing_model.dart';
// bool kDebugMode=true;
class ListingRepository {
  final ApiClient apiClient;

  ListingRepository({required this.apiClient});

  Future<int?> createListing(Listing listing, String token) async {
    if (kDebugMode) {
      print('Creating listing...');
    }
    try {
      final response = await apiClient.post(
        '/api/listing',
        body: listing.toJson(),
        token: token,
      );
      if (kDebugMode) {
        print('Create listing response status: ${response.statusCode}');
      }
      if (response.statusCode == 201) {
        return int.tryParse(response.body);
      } else {
        if (kDebugMode) {
          print('Failed to create listing. Body: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during listing creation: $e');
      }
      return null;
    }
  }

  Future<bool> approveListing(int postId, String token) async {
    if (kDebugMode) {
      print('Approving listing $postId...');
    }
    try {
      final response = await apiClient.patch(
        '/api/listing/approve/$postId',
        token: token,
      );
      if (kDebugMode) {
        print('Approve listing response status: ${response.statusCode}');
      }
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Exception during listing approval: $e');
      }
      return false;
    }
  }

  Future<List<Listing>> getApprovedListings(String token) async {
    if (kDebugMode) {
      print('Fetching approved listings...');
    }
    try {
      final response = await apiClient.get('/api/listing', token: token);
      if (kDebugMode) {
        print('Get approved listings status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Listing.fromJson(e)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during fetching approved listings: $e');
      }
    }
    return [];
  }

  Future<List<Listing>> getUnapprovedListings(String token) async {
    if (kDebugMode) {
      print('Fetching unapproved listings...');
    }
    try {
      final response = await apiClient.get('/api/listing/unapproved', token: token);
      if (kDebugMode) {
        print('Get unapproved listings status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Listing.fromJson(e)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during fetching unapproved listings: $e');
      }
    }
    return [];
  }
}
