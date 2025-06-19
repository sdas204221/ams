import 'package:flutter/foundation.dart';
import 'package:lms/data/models/listing_model.dart';
import 'package:lms/services/listing_service.dart';

class ListingProvider with ChangeNotifier {
  final ListingService listingService;

  List<Listing> _approvedListings = [];
  List<Listing> _unapprovedListings = [];
  // ✅ Categorized listings
  final List<Listing> _events = [];
  final List<Listing> _jobs = [];
  final List<Listing> _posts = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Listing> get approvedListings => _approvedListings;
  List<Listing> get unapprovedListings => _unapprovedListings;
  List<Listing> get events => _events;
  List<Listing> get jobs => _jobs;
  List<Listing> get posts => _posts;
  ListingProvider({required this.listingService});

  Future<void> fetchApprovedListings() async {
    _isLoading = true;
    _approvedListings = await listingService.getApprovedListings();

    _approvedListings.sort((a, b) {
      final aDate = a.approvalDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.approvalDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate); // Newest approvalDate first
    });
// ✅ Clear categorized lists
    _events.clear();
    _jobs.clear();
    _posts.clear();

    // ✅ Categorize listings
    for (var listing in _approvedListings) {
      if (listing.types.contains('event')) _events.add(listing);
      if (listing.types.contains('job')) _jobs.add(listing);
      if (listing.types.contains('post')) _posts.add(listing);
    }
    print(events.map((e){return e.eventDate;}));
    _isLoading = false;
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
    if (success != null) {
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
