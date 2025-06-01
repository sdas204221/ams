import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms/data/models/listing_model.dart';

class ListingDetailsScreen extends StatelessWidget {
  const ListingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Listing listing =
        ModalRoute.of(context)!.settings.arguments as Listing;

    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final approvalDateStr = listing.approvalDate != null
        ? dateFormat.format(listing.approvalDate!)
        : 'Pending Approval';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing Details'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: Theme.of(context).cardTheme.elevation,
              shape: Theme.of(context).cardTheme.shape,
              color: Theme.of(context).cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      listing.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Posted by:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: listing.username,
                        );
                      },
                      child: Text(
                        listing.username,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue.shade700,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Divider(color: Theme.of(context).dividerTheme.color),

                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 24),
                    Divider(color: Theme.of(context).dividerTheme.color),

                    Text(
                      'Type(s):',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: listing.types
                          .map(
                            (type) => Chip(
                              label: Text(
                                type[0].toUpperCase() + type.substring(1),
                                style: const TextStyle(fontFamily: 'Georgia'),
                              ),
                              backgroundColor: Colors.brown.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 24),
                    Divider(color: Theme.of(context).dividerTheme.color),

                    Text(
                      'Approval Date:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      approvalDateStr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.brown.shade700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
