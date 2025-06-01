import 'package:flutter/material.dart';
import 'package:lms/data/models/user_model.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _educationController = TextEditingController();
  final _jobDetailsController = TextEditingController();
  final _skillsController = TextEditingController();
  final _achievementsController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = User(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      roles: [],
    );

    final profile = Profile(
      user: user,
      education: _educationController.text.trim(),
      jobDetails: _jobDetailsController.text.trim(),
      skills: _skillsController.text.trim(),
      achievements: _achievementsController.text.trim(),
    );

    final success = await context.read<AuthProvider>().register(profile);

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please wait for approval.')),
        );
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _errorMessage = "Registration failed. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Alumni Account',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      if (_errorMessage != null) ...[
                        Text(_errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
                        const SizedBox(height: 12),
                      ],

                      _buildTextField('Username', _usernameController,
                          validator: (v) => v == null || v.isEmpty ? 'Enter username' : null),
                      _buildTextField('Email', _emailController,
                          validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null),
                      _buildTextField('Password', _passwordController,
                          obscure: true,
                          validator: (v) => v == null || v.length < 6 ? 'Password too short' : null),
                      _buildTextField('Education', _educationController),
                      _buildTextField('Job Details', _jobDetailsController),
                      _buildTextField('Skills (comma-separated)', _skillsController),
                      _buildTextField('Achievements', _achievementsController),

                      const SizedBox(height: 24),

                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Register'),
                            ),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscure = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
