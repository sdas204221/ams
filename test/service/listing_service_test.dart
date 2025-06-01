import 'package:lms/core/utils/api_client.dart';
import 'package:lms/data/models/listing_model.dart';
import 'package:lms/data/repositories/api/listing_repository.dart';
import 'package:lms/data/repositories/db/storage.dart';
import 'package:lms/services/listing_service.dart';

Future<void> runListingServiceTests(Storage mockStorage) async {
  //final mockStorage = MockStorage();
  //mockStorage.saveJwt('fake-jwt-token'); // Simulate a login

  final apiClient = ApiClient();
  final listingRepo = ListingRepository(apiClient: apiClient);
  final listingService = ListingService(listingRepo: listingRepo, storage: mockStorage);

  // 1. Create Listing Test
  final newListing = Listing(
    id: 0,
    username: 'testuser',
    title: 'Flutter Internship',
    description: 'Work on real-world Flutter apps.',
    creationDate: DateTime.now(),
    approvalDate: null,
    approved: false,
    types: ['Internship'],
  );

  final createSuccess = await listingService.createListing(newListing);
  print('Create Listing: ${createSuccess}');

  // 2. Get Approved Listings Test
  final approved = await listingService.getApprovedListings();
  print('Approved Listings Count: ${approved.length}');

  // 3. Get Unapproved Listings Test
  final unapproved = await listingService.getUnapprovedListings();
  print('Unapproved Listings Count: ${unapproved.length}');

  // 4. Approve Listing Test (using the first unapproved listing if exists)
  if (unapproved.isNotEmpty) {
    final success = await listingService.approveListing(unapproved.first.id!);
    print('Approve Listing ID ${unapproved.first.id}: ${success ? "PASS" : "FAIL"}');
  } else {
    print('No unapproved listings to approve.');
  }
}
