import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/providers/user_provider.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:lms/data/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile? _profile;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _fetchProfile(args);
    }
  }

  Future<void> _fetchProfile(String username) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profile = await userProvider.getProfile(username);
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Widget _buildField(String label, String? value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value?.trim().isEmpty ?? true ? 'N/A' : value!,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(IconData icon, String title, Widget content) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildRoles(List<Role> roles) {
    final theme = Theme.of(context);
    final chipColor = theme.colorScheme.primaryContainer;

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: roles
          .map(
            (role) => Chip(
              label: Text(role.name, style: theme.textTheme.bodyMedium),
              backgroundColor: chipColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roles = Provider.of<AuthProvider>(context).roles;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        actions: [
          if (roles.contains('admin') || roles.contains('moderator'))
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Profile',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/account',
                  arguments: _profile!.user.username,
                );
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text("Profile not found"))
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  _profile!.name?.trim().isEmpty ?? true
                                      ? 'Unnamed'
                                      : _profile!.name!,
                                  style: theme.textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _profile!.user.username,
                                  style: theme.textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _profile!.user.email,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildSection(
                            Icons.school,
                            "Education",
                            Column(
                              children: [
                                _buildField("Education", _profile!.education),
                                _buildField("Job Details", _profile!.jobDetails),
                              ],
                            ),
                          ),

                          _buildSection(
                            Icons.star,
                            "Achievements",
                            _buildField(
                              "Achievements",
                              _profile!.achievements?.replaceAll(',', ', '),
                            ),
                          ),

                          _buildSection(
                            Icons.build,
                            "Skills",
                            _buildField(
                              "Skills",
                              _profile!.skills?.replaceAll(',', ', '),
                            ),
                          ),

                          _buildSection(
                            Icons.verified_user,
                            "Roles",
                            _buildRoles(_profile!.user.roles),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
