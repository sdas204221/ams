import 'package:flutter/material.dart';
import 'package:lms/providers/user_provider.dart';
import 'package:lms/widgets/web_header.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/listing_provider.dart';
import '../widgets/listing_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ListingProvider>(context, listen: false)
          .fetchApprovedListings();
      Provider.of<UserProvider>(context, listen: false).getAllUsernames();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final listingProvider = Provider.of<ListingProvider>(context);
    var listings = listingProvider.approvedListings;
    final roles = authProvider.roles;
    if (listingProvider.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
    final events = listingProvider.events;
    listings.removeWhere((l){return l.types.contains("event");});
    final theme = Theme.of(context);
    print("s");
  print(events);
    // Sort events by closest eventDate
    final upcomingEvents = [...events]
      ..removeWhere((e) => e.eventDate == null|| e.eventDate!.isBefore(DateTime.now()))
      ..sort((a, b) => a.eventDate!.compareTo(b.eventDate!));

    final top10Events = upcomingEvents.toList();

    return Scaffold(
      body: Column(
        children: [
          WebHeader(
            theme: theme,
            roles: roles,
            onLogout: () async {
              await authProvider.logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: listings.isEmpty
                      ? Center(
                          child: Text(
                            'No approved listings found.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.brown[700],
                            ),
                          ),
                        )
                      : Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: ListView.separated(
                                itemCount: listings.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final listing = listings[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/listing-details',
                                        arguments: listing,
                                      );
                                    },
                                    child: ListingCard(listing: listing),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                ),
                //const SizedBox(width: 16),
                VerticalDivider(),
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  //color: Colors.grey.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: top10Events.length,
                          itemBuilder: (context, index) {
                            final event = top10Events[index];
                            return EventPreviewCard(listing: event);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create-listing');
        },
        icon: const Icon(Icons.add),
        label: const Text('Post Listing'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class EventPreviewCard extends StatelessWidget {
  final listing;

  const EventPreviewCard({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = listing.eventDate;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/listing-details',
            arguments: listing,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      date != null ? '${date.day}' : '--',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      date != null ? '${_monthShort(date.month)}' : '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Posted by ${listing.username}',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _monthShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
