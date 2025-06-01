import 'package:flutter/material.dart';
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
    Future.microtask(() =>
        Provider.of<ListingProvider>(context, listen: false)
            .fetchApprovedListings());
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final listingProvider = Provider.of<ListingProvider>(context);
    final listings = listingProvider.approvedListings;
    final roles = authProvider.roles;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authProvider.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: roles.contains('admin') || roles.contains('moderator')
          ? Drawer(
              child: Container(
                color: theme.scaffoldBackgroundColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(color: theme.primaryColor),
                      child: Text(
                        'Admin Actions',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: const Text('Approve Listings'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin/approve-listings');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Approve Users'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin/approve-users');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings),
                      title: const Text('Assign Roles'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/admin/assign-roles');
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: listings.isEmpty
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create-listing');
        },
        icon: const Icon(Icons.add),
        label: const Text('Post Listing'),
        backgroundColor: theme.primaryColor, // or use theme.colorScheme.secondary
        foregroundColor: Colors.white,
      ),
    );
  }
}
