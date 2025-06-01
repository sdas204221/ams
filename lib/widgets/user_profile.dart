import 'package:flutter/material.dart';
import 'package:lms/data/models/user_model.dart';

class UserProfile extends StatelessWidget {
  final Profile profile;

  const UserProfile({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = profile.user;
    final String? profileImageUrl = profile.profilePicture;
    final String username = user.username;
    final String email = user.email;
    final String education = profile.education ?? 'N/A';
    final String jobDetails = profile.jobDetails ?? 'N/A';
    final String skills = profile.skills ?? 'N/A';
    final String achievements = profile.achievements ?? 'N/A';

    // Responsive horizontal padding based on screen width
    final horizontalPadding = MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      shape: theme.cardTheme.shape,
      color: theme.cardColor,
      elevation: theme.cardTheme.elevation ?? 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Username
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileAvatar(profileImageUrl, theme),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    username,
                    style: theme.textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email row
            _buildIconInfoRow(
              icon: Icons.email,
              label: email,
              theme: theme,
              labelStyle: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Divider between header and info
            Divider(color: theme.dividerTheme.color, thickness: theme.dividerTheme.thickness),

            const SizedBox(height: 12),

            // Other info fields with vintage label style and spacing
            _buildLabeledInfo("Education", education, theme),
            _buildLabeledInfo("Job Details", jobDetails, theme),
            _buildLabeledInfo("Skills", skills, theme),
            _buildLabeledInfo("Achievements", achievements, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String? imageUrl, ThemeData theme) {
    final borderColor = theme.primaryColor;
    final double radius = 34;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: radius - 2,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: theme.cardColor,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
        ),
        child: CircleAvatar(
          radius: radius - 2,
          backgroundColor: theme.cardColor,
          child: Icon(Icons.person, size: 36, color: borderColor),
        ),
      );
    }
  }

  Widget _buildIconInfoRow({
    required IconData icon,
    required String label,
    required ThemeData theme,
    TextStyle? labelStyle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.iconTheme.color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: labelStyle ?? theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledInfo(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyLarge,
          children: [
            TextSpan(
              text: '$label: ',
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
