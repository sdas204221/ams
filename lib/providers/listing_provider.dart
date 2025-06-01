import 'package:flutter/foundation.dart';
import 'package:lms/data/models/listing_model.dart';
import 'package:lms/services/listing_service.dart';

class ListingProvider with ChangeNotifier {
  final ListingService listingService;

  List<Listing> _approvedListings = [];
  List<Listing> _unapprovedListings = [];

  List<Listing> get approvedListings => _approvedListings;
  List<Listing> get unapprovedListings => _unapprovedListings;

  ListingProvider({required this.listingService});

  Future<void> fetchApprovedListings() async {
  _approvedListings = await listingService.getApprovedListings();

  _approvedListings.sort((a, b) {
    final aDate = a.approvalDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bDate = b.approvalDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate); // Newest approvalDate first
  });

  notifyListeners();
}


  Future<void> fetchUnapprovedListings() async {
    _unapprovedListings = await listingService.getUnapprovedListings();
    _unapprovedListings.sort((a, b) {
    final aDate = a.creationDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bDate = b.creationDate ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate); // Newest approvalDate first
  });
    notifyListeners();
  }

  Future<int?> createListing(Listing listing) async {
    final success = await listingService.createListing(listing);
    if (success!=null) {
      await fetchUnapprovedListings(); // refresh listings
    }
    return success;
  }

  Future<bool> approveListing(int id) async {
    final success = await listingService.approveListing(id);
    if (success) {
      await fetchApprovedListings();
      await fetchUnapprovedListings();
    }
    return success;
  }
}
