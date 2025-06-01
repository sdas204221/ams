import 'package:lms/data/models/listing_model.dart';
import 'package:lms/data/repositories/api/listing_repository.dart';
import 'package:lms/data/repositories/db/storage.dart';

class ListingService {
  final ListingRepository listingRepo;
  final Storage storage;

  ListingService({required this.listingRepo, required this.storage});

  Future<int?> createListing(Listing listing) async {
    final token = storage.getJwt();
    if (token == null) {
      print('No token found. Cannot create listing.');
      throw Exception('No token found. Cannot create listing.');
    }

    final listingId = await listingRepo.createListing(listing, token);
    return listingId;
  }

  Future<List<Listing>> getApprovedListings() async {
    final token = storage.getJwt();
    if (token == null) {
      print('No token found. Returning empty approved listings.');
      return [];
    }

    return await listingRepo.getApprovedListings(token);
  }

  Future<List<Listing>> getUnapprovedListings() async {
    final token = storage.getJwt();
    if (token == null) {
      print('No token found. Returning empty unapproved listings.');
      return [];
    }

    return await listingRepo.getUnapprovedListings(token);
  }

  Future<bool> approveListing(int id) async {
    final token = storage.getJwt();
    if (token == null) {
      print('No token found. Cannot approve listing.');
      return false;
    }

    return await listingRepo.approveListing(id, token);
  }
}
