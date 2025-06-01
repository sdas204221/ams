import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/providers/user_provider.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(
                "$label:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              )),
          Expanded(
            child: Text(
              value?.trim().isEmpty ?? true ? 'N/A' : value!,
              style: const TextStyle(
                fontFamily: 'Georgia',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(IconData icon, String title, Widget content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.brown.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                    color: Colors.brown.shade700,
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
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: roles
          .map(
            (role) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role.name,
                style: const TextStyle(fontFamily: 'Georgia'),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
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
                          // Name and email (simple, no card)
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  _profile!.user.username,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _profile!.user.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                    fontFamily: 'Georgia',
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
