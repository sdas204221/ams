import 'package:flutter/material.dart';
import 'package:lms/widgets/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:lms/data/models/user_model.dart';
import 'package:lms/providers/user_provider.dart';

class ApproveUsersScreen extends StatefulWidget {
  const ApproveUsersScreen({super.key});

  @override
  State<ApproveUsersScreen> createState() => _ApproveUsersScreenState();
}

class _ApproveUsersScreenState extends State<ApproveUsersScreen> {
  List<Profile> _pendingUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingUsers();
  }

  Future<void> _fetchPendingUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profiles = await userProvider.getPendingUsers();
    setState(() {
      _pendingUsers = profiles ?? [];
      _isLoading = false;
    });
  }

  Future<void> _approveUser(String username) async {
    final success = await Provider.of<UserProvider>(context, listen: false).approveUser(username);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Approved $username')),
      );
      _fetchPendingUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve $username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Approve Users")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              )
            : _pendingUsers.isEmpty
                ? Center(
                    child: Text(
                      "No users pending approval",
                      style: theme.textTheme.titleLarge?.copyWith(color: theme.primaryColor),
                    ),
                  )
                : ListView.separated(
                    itemCount: _pendingUsers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final profile = _pendingUsers[index];
                      return Column(
                        children: [
                          UserProfile(profile: profile),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ElevatedButton.icon(
                              onPressed: () => _approveUser(profile.user.username),
                              icon: const Icon(Icons.check),
                              label: const Text("Approve"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                textStyle: theme.textTheme.labelLarge,
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
