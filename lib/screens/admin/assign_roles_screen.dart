import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/providers/user_provider.dart';

class AssignRolesScreen extends StatefulWidget {
  const AssignRolesScreen({super.key});

  @override
  State<AssignRolesScreen> createState() => _AssignRolesScreenState();
}

class _AssignRolesScreenState extends State<AssignRolesScreen> {
  final _usernameController = TextEditingController();
  final Map<String, bool> _roleSelection = {
    'user': false,
    'moderator': false,
    'admin': false,
  };

  bool _isLoading = false;
  String? _message;

  Future<void> _assignRoles() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final username = _usernameController.text.trim();
    final selectedRoles = _roleSelection.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (username.isEmpty || selectedRoles.isEmpty) {
      setState(() {
        _isLoading = false;
        _message = 'Username and at least one role are required.';
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.assignRoles(username, selectedRoles);

    setState(() {
      _isLoading = false;
      _message = success ? 'Roles assigned successfully.' : 'Failed to assign roles.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Assign Roles')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: theme.cardTheme.elevation ?? 2,
              shape: theme.cardTheme.shape,
              color: theme.cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Assign Roles',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Username input
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),

                    // Section Header for Roles
                    Row(
                      children: [
                        Icon(Icons.assignment_ind, color: theme.iconTheme.color, size: 26),
                        const SizedBox(width: 8),
                        Text('Select Roles:', style: theme.textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Roles checkboxes custom styled
                    ..._roleSelection.keys.map(
                      (role) => InkWell(
                        onTap: () {
                          setState(() {
                            _roleSelection[role] = !_roleSelection[role]!;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                fillColor: MaterialStateProperty.resolveWith<Color?>(
                                  (states) => theme.primaryColor,
                                ),
                                value: _roleSelection[role],
                                onChanged: (val) {
                                  setState(() {
                                    _roleSelection[role] = val ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Text(
                                role[0].toUpperCase() + role.substring(1),
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action area
                    if (_isLoading)
                      Center(child: CircularProgressIndicator(color: theme.primaryColor))
                    else
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _assignRoles,
                          child: Text('Assign', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                        ),
                      ),

                    if (_message != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        _message!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _message!.startsWith('Failed') ? Colors.red : Colors.green,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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
