import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/data/models/listing_model.dart';
import 'package:lms/providers/auth_provider.dart';
import 'package:lms/providers/listing_provider.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _selectedTypes = [];

  final List<String> _allTypes = ['job', 'event', 'post'];
  bool _isLoading = false;

  void _toggleType(String type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select at least one type.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);

    final newListing = Listing(
      username: authProvider.jwt ?? 'unknown', // replace with actual username if needed
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      types: _selectedTypes,
    );

    final result = await listingProvider.createListing(newListing);

    setState(() => _isLoading = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing created successfully!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create listing.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 8, // Increased height
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter description' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Type(s)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 10,
                    children: _allTypes.map((type) {
                      final isSelected = _selectedTypes.contains(type);
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (_) => _toggleType(type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Submit'),
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
