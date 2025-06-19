import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/providers/user_provider.dart';
import 'package:lms/data/models/user_model.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Profile? _profile;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _educationController;
  late TextEditingController _jobDetailsController;
  late TextEditingController _skillsController;
  late TextEditingController _achievementsController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _fetchProfileOthers(args);
    }else if (_profile == null) {
      _fetchProfile();
    }
  }

Future<void> _fetchProfileOthers(String username) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profile = await userProvider.getProfile(username);

    if (profile != null) {
      _nameController = TextEditingController(text: profile.name ?? '');
      _educationController = TextEditingController(text: profile.education ?? '');
      _jobDetailsController = TextEditingController(text: profile.jobDetails ?? '');
      _skillsController = TextEditingController(text: profile.skills ?? '');
      _achievementsController = TextEditingController(text: profile.achievements ?? '');
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
    }

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _fetchProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profile = await userProvider.getMyProfile();

    if (profile != null) {
      _nameController = TextEditingController(text: profile.name ?? '');
      _educationController = TextEditingController(text: profile.education ?? '');
      _jobDetailsController = TextEditingController(text: profile.jobDetails ?? '');
      _skillsController = TextEditingController(text: profile.skills ?? '');
      _achievementsController = TextEditingController(text: profile.achievements ?? '');
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
    }

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _educationController.dispose();
    _jobDetailsController.dispose();
    _skillsController.dispose();
    _achievementsController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (password.isNotEmpty && password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      final updatedUser = _profile!.user.copyWith(
        password: password.isNotEmpty ? password : null,
      );

      final updatedProfile = Profile(
        id: _profile!.id,
        name: _nameController.text,
        education: _educationController.text,
        jobDetails: _jobDetailsController.text,
        skills: _skillsController.text,
        achievements: _achievementsController.text,
        profilePicture: _profile!.profilePicture,
        user: updatedUser,
      );

      final result = await Provider.of<UserProvider>(context, listen: false)
          .updateProfile(updatedProfile);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        setState(() {
          _profile = result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")),
        );
      }
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: obscureText ? 1 : maxLines,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: toggleVisibility != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
        ),
        validator: (value) => null,
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Profile")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text("Profile not found"))
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      color: const Color.fromARGB(255, 133, 180, 241),
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildTextField("Name", _nameController),
                            _buildTextField("Education", _educationController),
                            _buildTextField("Job Details", _jobDetailsController, maxLines: 2),
                            _buildTextField("Skills (comma separated)", _skillsController, maxLines: 2),
                            _buildTextField("Achievements (comma separated)", _achievementsController, maxLines: 2),

                            _buildTextField(
                              "New Password",
                              _passwordController,
                              obscureText: _obscurePassword,
                              toggleVisibility: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                            _buildTextField(
                              "Confirm Password",
                              _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              toggleVisibility: () {
                                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                              },
                            ),

                            const SizedBox(height: 16),
                            const Text(
                              "Roles",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildRoles(_profile!.user.roles),

                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _updateProfile,
                              icon: const Icon(Icons.save),
                              label: const Text("Update Profile"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
