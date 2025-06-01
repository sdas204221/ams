

import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/models/listing_model.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/api/listing_repository.dart';

void main() async {
  final apiClient = ApiClient();
  final authRepo = AuthRepository(apiClient: apiClient);
  final listingRepo = ListingRepository(apiClient: apiClient);

  const username = 'ss';
  const password = 'password123';

  print('--- Logging in to get JWT token ---');
  final loginResult = await authRepo.login(username, password);

  final token = loginResult['jwt'] ?? '';
  if (token.isEmpty) {
    print('JWT token not found. Cannot proceed.');
    return;
  }

  print('JWT token retrieved: $token');

  print('\n--- Starting createListing test ---');
  final newListing = Listing(
    id: 0,
    username: username,
    title: 'Test Listing',
    description: 'This is a test listing created for unit test.',
    creationDate: DateTime.now(),
    approvalDate: null,
    approved: false,
    types: ['announcement', 'event'],
  );

  final listingId = await listingRepo.createListing(newListing, token);
  if (listingId != null) {
    print('Listing created successfully with ID: $listingId');
  } else {
    print('Listing creation failed.');
    return;
  }

  print('\n--- Starting approveListing test ---');
  final approvalResult = await listingRepo.approveListing(listingId, token);
  if (approvalResult) {
    print('Listing approved successfully.');
  } else {
    print('Listing approval failed.');
  }

  print('\n--- Fetching approved listings ---');
  final approvedListings = await listingRepo.getApprovedListings(token);
  print('Approved listings count: ${approvedListings.length}');
  for (var listing in approvedListings) {
    print('Approved Listing: ${listing.id} - ${listing.title}');
  }

  print('\n--- Fetching unapproved listings ---');
  final unapprovedListings = await listingRepo.getUnapprovedListings(token);
  print('Unapproved listings count: ${unapprovedListings.length}');
  for (var listing in unapprovedListings) {
    print('Unapproved Listing: ${listing.id} - ${listing.title}');
  }
}
