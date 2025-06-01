import 'package:flutter/material.dart';
import 'package:lms/my_theme.dart';
import 'package:provider/provider.dart';
import 'package:lms/providers/listing_provider.dart';
import 'package:lms/widgets/listing_card.dart';

class ApproveListingsScreen extends StatefulWidget {
  const ApproveListingsScreen({super.key});

  @override
  State<ApproveListingsScreen> createState() => _ApproveListingsScreenState();
}

class _ApproveListingsScreenState extends State<ApproveListingsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnapprovedListings();
  }

  Future<void> _loadUnapprovedListings() async {
    await Provider.of<ListingProvider>(context, listen: false).fetchUnapprovedListings();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _approveListing(int id) async {
    final success = await Provider.of<ListingProvider>(context, listen: false).approveListing(id);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing approved!')),
        );
        // Refresh listings after approval
        _loadUnapprovedListings();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to approve listing.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unapprovedListings = Provider.of<ListingProvider>(context).unapprovedListings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve Listings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUnapprovedListings,
              child: unapprovedListings.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 100),
                        Icon(Icons.inbox, size: 80, color: theme.colorScheme.primary.withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'No unapproved listings available.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.primary.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Center content on large screens with max width
                        final maxWidth = constraints.maxWidth > 800 ? 700.0 : constraints.maxWidth;
                        return Center(
                          child: Container(
                            width: maxWidth,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pending Approvals', style: theme.sectionHeaderTextStyle),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: unapprovedListings.length,
                                    separatorBuilder: (context, index) => Divider(color: theme.dividerTheme.color, thickness: theme.dividerTheme.thickness),
                                    itemBuilder: (context, index) {
                                      final listing = unapprovedListings[index];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ListingCard(listing: listing),
                                              const SizedBox(height: 12),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton.icon(
                                                  onPressed: () => _approveListing(listing.id!),
                                                  icon: const Icon(Icons.check),
                                                  label: const Text('Approve'),
                                                  style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                                    textStyle: theme.textTheme.labelLarge,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
