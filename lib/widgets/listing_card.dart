import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms/data/models/listing_model.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;

  const ListingCard({super.key, required this.listing});

  Color _getCardColor(BuildContext context) {
    // These could also be added to your theme extensions or colorScheme for better reuse.
    const multipleColor = Color(0xFF3B0404);
    const jobColor = Color(0xFF7C6B58);
    const postColor = Color(0xFFA45C40);
    const eventColor = Color(0xFFC38370);

    final theme = Theme.of(context);

    // if (listing.types.length > 1) {
    //   return multipleColor;
    // } else if (listing.types.contains('job')) {
    //   return jobColor;
    // } else if (listing.types.contains('post')) {
    //   return postColor;
    // } else if (listing.types.contains('event')) {
    //   return eventColor;
    // } else {
    //   return theme.cardColor;
    // }
    return theme.cardColor;
  }

  String _getPrimaryTypeLabel() {
    if (listing.types.length > 1) {
      return 'Multiple';
    } else if (listing.types.isNotEmpty) {
      return listing.types.first.capitalize();
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final approvalDateStr = listing.approvalDate != null
        ? dateFormat.format(listing.approvalDate!)
        : 'N/A';

    final theme = Theme.of(context);

    // Use dark brown for text, but lighten text color on darker card backgrounds.
    final cardColor = _getCardColor(context);
    final isDarkBackground = cardColor.computeLuminance() < 0.5;
    final textColor = isDarkBackground ? Colors.white :theme.primaryColor;

    return Card(
      color: cardColor,
      elevation: theme.cardTheme.elevation ?? 2,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: theme.cardTheme.margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posted by: ${listing.username.isNotEmpty ? listing.username : 'Unknown'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              listing.title.isNotEmpty ? listing.title : 'No Title',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            if (listing.description.isNotEmpty)
              Text(
                listing.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor.withOpacity(0.85),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 12),
            Divider(color: textColor.withOpacity(0.3)),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted on: $approvalDateStr',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getPrimaryTypeLabel(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
