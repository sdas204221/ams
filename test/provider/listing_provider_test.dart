import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/repositories/api/auth_repository.dart';
import 'package:lms/data/repositories/api/listing_repository.dart';
import 'package:lms/data/repositories/db/mock_storage.dart';
import 'package:lms/data/models/listing_model.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:lms/providers/listing_provider.dart';
import 'package:lms/services/auth_service.dart';
import 'package:lms/services/listing_service.dart';

void main() async {
  final listingRepo = ListingRepository(apiClient: ApiClient()); // Replace with mock or test version
  final storage = MockStorage();               // Should have test JWT data
  final listingService = ListingService(listingRepo: listingRepo, storage: storage);
  final listingProvider = ListingProvider(listingService: listingService);
  final authRepo = AuthRepository(apiClient: ApiClient()); 
  final authService = AuthService(authRepo, storage);
  final authProvider = AuthProvider(authService: authService);
  await authProvider.login('ss', 'password123');
  print('Fetching approved listings...');
  await listingProvider.fetchApprovedListings();
  print('Approved Listings Count: ${listingProvider.approvedListings.length}');

  print('Fetching unapproved listings...');
  await listingProvider.fetchUnapprovedListings();
  print('Unapproved Listings Count: ${listingProvider.unapprovedListings.length}');

  print('Creating new listing...');
  Listing newListing = Listing(
    title: 'Test Listing',
    description: 'This is a test listing.',
    username: 'test_user',
    types: ['job']
  );

  int? created = await listingProvider.createListing(newListing);
  print('Listing Created: $created');

  print('Approving listing with ID $created...');
  bool approved = await listingProvider.approveListing(created!);
  print('Listing Approved: $approved');
}
